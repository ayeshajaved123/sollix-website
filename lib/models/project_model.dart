import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String
      category; // commercial | residential | industrial | infrastructure
  final String imageUrl;
  final int order;

  ProjectModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.order,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'order': order,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
