import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ContactSubmissionsScreen extends StatelessWidget {
  const ContactSubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('contactSubmissions')
        .orderBy('submittedAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: Text('Contact Submissions',
            style: AppTextStyles.body(
                size: 16, weight: FontWeight.w700, color: AppColors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading submissions: ${snapshot.error}',
                  style: AppTextStyles.body(color: AppColors.primaryRed)),
            );
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text('No messages yet.', style: AppTextStyles.body()),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final Timestamp? ts = data['submittedAt'] as Timestamp?;
              final dateLabel = ts != null ? _formatDate(ts.toDate()) : '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['name'] ?? '(no name)',
                            style: AppTextStyles.body(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.primaryNavy),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.primaryRed, size: 20),
                            onPressed: () => docs[index].reference.delete(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(dateLabel,
                          style: AppTextStyles.body(
                              size: 11.5, color: AppColors.mutedText)),
                      const SizedBox(height: 10),
                      _InfoRow(
                          icon: Icons.email_outlined,
                          text: data['email'] ?? ''),
                      if ((data['phone'] ?? '').toString().isNotEmpty)
                        _InfoRow(
                            icon: Icons.phone_outlined, text: data['phone']),
                      const SizedBox(height: 10),
                      Text(data['message'] ?? '',
                          style: AppTextStyles.body(size: 13.5)),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.body(size: 12.5)),
        ],
      ),
    );
  }
}
