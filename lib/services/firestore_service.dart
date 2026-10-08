import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';

/// Single place for ALL Firestore reads/writes. UI code never talks to
/// Firestore directly — it calls these functions instead.
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // ---------------- PROJECTS ----------------

  Stream<List<ProjectModel>> watchProjects() {
    return _db
        .collection('projects')
        .orderBy('order')
        .snapshots()
        .map((snap) => snap.docs.map(ProjectModel.fromFirestore).toList());
  }

  Future<void> addProject(ProjectModel project) {
    return _db.collection('projects').add(project.toMap());
  }

  Future<void> updateProject(String id, Map<String, dynamic> data) {
    return _db.collection('projects').doc(id).update(data);
  }

  Future<void> deleteProject(String id) {
    return _db.collection('projects').doc(id).delete();
  }

  // ---------------- SERVICES ----------------

  Stream<List<ServiceModel>> watchServices() {
    return _db
        .collection('services')
        .orderBy('order')
        .snapshots()
        .map((snap) => snap.docs.map(ServiceModel.fromFirestore).toList());
  }

  Future<void> addService(ServiceModel service) {
    return _db.collection('services').add(service.toMap());
  }

  Future<void> updateService(String id, Map<String, dynamic> data) {
    return _db.collection('services').doc(id).update(data);
  }

  Future<void> deleteService(String id) {
    return _db.collection('services').doc(id).delete();
  }

  // ---------------- CONTACT FORM ----------------

  Future<void> submitContactForm({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) {
    return _db.collection('contactSubmissions').add({
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}
