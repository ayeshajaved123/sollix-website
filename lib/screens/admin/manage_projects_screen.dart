import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/project_model.dart';
import '../../services/firestore_service.dart';
import '../../services/cloudinary_service.dart';

class ManageProjectsScreen extends StatelessWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: Text('Manage Projects',
            style: AppTextStyles.body(
                size: 16, weight: FontWeight.w700, color: AppColors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Add Project', style: AppTextStyles.button()),
        onPressed: () => _openProjectForm(context),
      ),
      body: StreamBuilder<List<ProjectModel>>(
        stream: firestoreService.watchProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading projects: ${snapshot.error}',
                  style: AppTextStyles.body(color: AppColors.primaryRed)),
            );
          }
          final projects = snapshot.data ?? [];
          if (projects.isEmpty) {
            return Center(
              child: Text('No projects yet — tap "Add Project" to create one.',
                  style: AppTextStyles.body()),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      project.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.borderGrey,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  title: Text(project.title,
                      style: AppTextStyles.body(
                          weight: FontWeight.w700,
                          color: AppColors.primaryNavy)),
                  subtitle: Text(
                      '${project.category} • order: ${project.order}',
                      style: AppTextStyles.body(size: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.primaryNavy),
                        onPressed: () =>
                            _openProjectForm(context, existing: project),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.primaryRed),
                        onPressed: () => _confirmDelete(context, project),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text(
            'This will remove "${project.title}" from the public website.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              FirestoreService().deleteProject(project.id);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }

  void _openProjectForm(BuildContext context, {ProjectModel? existing}) {
    showDialog(
      context: context,
      builder: (context) => _ProjectFormDialog(existing: existing),
    );
  }
}

class _ProjectFormDialog extends StatefulWidget {
  final ProjectModel? existing;
  const _ProjectFormDialog({this.existing});

  @override
  State<_ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<_ProjectFormDialog> {
  final _firestoreService = FirestoreService();
  final _cloudinaryService = CloudinaryService();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _orderController =
      TextEditingController(text: (widget.existing?.order ?? 0).toString());

  String _category = 'commercial';
  Uint8List? _pickedImageBytes;
  String? _existingImageUrl;
  bool _saving = false;
  String? _error;

  static const _categories = [
    'commercial',
    'residential',
    'industrial',
    'infrastructure'
  ];

  @override
  void initState() {
    super.initState();
    _existingImageUrl = widget.existing?.imageUrl;
    if (widget.existing != null &&
        _categories.contains(widget.existing!.category)) {
      _category = widget.existing!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _pickedImageBytes = bytes);
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter a title.');
      return;
    }
    if (_pickedImageBytes == null && _existingImageUrl == null) {
      setState(() => _error = 'Please choose an image.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      String imageUrl = _existingImageUrl ?? '';
      if (_pickedImageBytes != null) {
        imageUrl = await _cloudinaryService.uploadImage(
          _pickedImageBytes!,
          '${_titleController.text.trim()}_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      if (widget.existing == null) {
        await _firestoreService.addProject(ProjectModel(
          id: '',
          title: _titleController.text.trim(),
          category: _category,
          imageUrl: imageUrl,
          order: order,
        ));
      } else {
        await _firestoreService.updateProject(widget.existing!.id, {
          'title': _titleController.text.trim(),
          'category': _category,
          'imageUrl': imageUrl,
          'order': order,
        });
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Project' : 'Edit Project'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Display order (1, 2, 3...)'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('Choose Image'),
              ),
              const SizedBox(height: 10),
              if (_pickedImageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.memory(_pickedImageBytes!,
                      height: 120, fit: BoxFit.cover),
                )
              else if (_existingImageUrl != null &&
                  _existingImageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(_existingImageUrl!,
                      height: 120, fit: BoxFit.cover),
                ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: const TextStyle(
                        color: AppColors.primaryRed, fontSize: 12.5)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style:
              ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
          child: _saving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
