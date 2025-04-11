import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/posts/model/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> fetchPosts() async {
    final snapshot = await _firestore.collection('post').get();
    return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
  }

  Future<void> addPost(PostModel post) async {
    await _firestore.collection('post').add(post.toJson());
  }
}
