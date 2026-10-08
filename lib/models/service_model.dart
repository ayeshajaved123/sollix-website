import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String title;
  final String icon; // icon name string, e.g. "plumbing"
  final int order;

  ServiceModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.order,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? 'build',
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'order': order,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
