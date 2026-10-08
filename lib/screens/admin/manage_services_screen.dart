import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/service_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/icon_mapper.dart';

class ManageServicesScreen extends StatelessWidget {
  const ManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: Text('Manage Services',
            style: AppTextStyles.body(
                size: 16, weight: FontWeight.w700, color: AppColors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Add Service', style: AppTextStyles.button()),
        onPressed: () => _openServiceForm(context),
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: firestoreService.watchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading services: ${snapshot.error}',
                  style: AppTextStyles.body(color: AppColors.primaryRed)),
            );
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return Center(
              child: Text('No services yet — tap "Add Service" to create one.',
                  style: AppTextStyles.body()),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(IconMapper.iconFor(service.icon),
                        color: AppColors.white),
                  ),
                  title: Text(service.title,
                      style: AppTextStyles.body(
                          weight: FontWeight.w700,
                          color: AppColors.primaryNavy)),
                  subtitle: Text('order: ${service.order}',
                      style: AppTextStyles.body(size: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.primaryNavy),
                        onPressed: () =>
                            _openServiceForm(context, existing: service),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.primaryRed),
                        onPressed: () => _confirmDelete(context, service),
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

  void _confirmDelete(BuildContext context, ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete service?'),
        content: Text(
            'This will remove "${service.title}" from the public website.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              FirestoreService().deleteService(service.id);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }

  void _openServiceForm(BuildContext context, {ServiceModel? existing}) {
    showDialog(
      context: context,
      builder: (context) => _ServiceFormDialog(existing: existing),
    );
  }
}

class _ServiceFormDialog extends StatefulWidget {
  final ServiceModel? existing;
  const _ServiceFormDialog({this.existing});

  @override
  State<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<_ServiceFormDialog> {
  final _firestoreService = FirestoreService();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _orderController =
      TextEditingController(text: (widget.existing?.order ?? 0).toString());

  late String _icon = widget.existing?.icon ?? IconMapper.names.first;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter a title.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      if (widget.existing == null) {
        await _firestoreService.addService(ServiceModel(
          id: '',
          title: _titleController.text.trim(),
          icon: _icon,
          order: order,
        ));
      } else {
        await _firestoreService.updateService(widget.existing!.id, {
          'title': _titleController.text.trim(),
          'icon': _icon,
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
      title: Text(widget.existing == null ? 'Add Service' : 'Edit Service'),
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
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _icon,
                decoration: const InputDecoration(labelText: 'Icon'),
                items: IconMapper.names
                    .map((name) => DropdownMenuItem(
                          value: name,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(IconMapper.iconFor(name),
                                  size: 18, color: AppColors.primaryNavy),
                              const SizedBox(width: 8),
                              Text(name),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _icon = value ?? _icon),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Display order (1, 2, 3...)'),
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
