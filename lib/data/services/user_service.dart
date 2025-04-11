import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/users/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').add(user.toJson());
  }

  Stream<List<UserModel>> streamUsers() {
  return _firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  });
}

}
