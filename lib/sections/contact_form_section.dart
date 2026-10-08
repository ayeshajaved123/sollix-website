import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/section_header.dart';
import '../services/firestore_service.dart';

class ContactFormSection extends StatefulWidget {
  const ContactFormSection({super.key});

  @override
  State<ContactFormSection> createState() => _ContactFormSectionState();
}

class _ContactFormSectionState extends State<ContactFormSection> {
  final _firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      setState(() => _error = 'Please fill in your name, email, and message.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _firestoreService.submitContactForm(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _submitted = true;
        _submitting = false;
      });
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong — please try again.';
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool desktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.lightGrey,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 70,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SectionHeader(
            eyebrow: 'GET IN TOUCH',
            title: 'SEND US A MESSAGE',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'Have a project in mind or need a fire protection consultation? '
              'Fill out the form below and our team will get back to you.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13.5),
            ),
          ),
          const SizedBox(height: 36),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: desktop ? 680 : double.infinity),
            child: _submitted ? _buildSuccessState() : _buildForm(desktop),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSuccessState() {
    return _card(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 30),
          ),
          const SizedBox(height: 18),
          Text('Message sent!',
              style: AppTextStyles.body(
                  size: 18,
                  weight: FontWeight.w700,
                  color: AppColors.primaryNavy)),
          const SizedBox(height: 8),
          Text(
            'Thanks for reaching out — our team will get back to you shortly.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 13.5),
          ),
          const SizedBox(height: 22),
          CustomButton(
            label: 'SEND ANOTHER',
            onPressed: () => setState(() => _submitted = false),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool desktop) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(_nameController,
                          label: 'Full Name',
                          hint: 'John Smith',
                          icon: Icons.person_outline),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _field(_emailController,
                          label: 'Email Address',
                          hint: 'you@example.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _field(_nameController,
                        label: 'Full Name',
                        hint: 'John Smith',
                        icon: Icons.person_outline),
                    const SizedBox(height: 20),
                    _field(_emailController,
                        label: 'Email Address',
                        hint: 'you@example.com',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress),
                  ],
                ),
          const SizedBox(height: 20),
          _field(_phoneController,
              label: 'Phone Number (optional)',
              hint: '+971 5X XXX XXXX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          _field(_messageController,
              label: 'Your Message',
              hint: 'Tell us about your project or requirement...',
              icon: Icons.chat_bubble_outline,
              maxLines: 5),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 16, color: AppColors.primaryRed),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(_error!,
                      style: AppTextStyles.body(
                          size: 12.5, color: AppColors.primaryRed)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: _submitting
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : CustomButton(
                      label: 'SEND MESSAGE',
                      icon: Icons.send_outlined,
                      onPressed: _submit,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller, {
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.body(
                size: 12.5,
                weight: FontWeight.w700,
                color: AppColors.primaryNavy)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTextStyles.body(size: 14, color: AppColors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTextStyles.body(size: 13.5, color: AppColors.mutedText),
            filled: true,
            fillColor: AppColors.lightGrey,
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  bottom: maxLines > 1 ? (20.0 * (maxLines - 1)) : 0),
              child: Icon(icon, size: 19, color: AppColors.primaryRed),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
