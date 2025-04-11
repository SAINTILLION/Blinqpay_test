import '../services/post_service.dart';
import '../../features/posts/model/post_model.dart';

class PostRepository {
  final PostService postService;

  PostRepository(this.postService);

  Future<List<PostModel>> getPosts() => postService.fetchPosts();
  Future<void> addPost(PostModel post) => postService.addPost(post);
}
