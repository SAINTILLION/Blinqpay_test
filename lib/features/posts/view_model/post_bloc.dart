import 'package:blinqpay_test/data/repositories/post_repository.dart';
import 'package:blinqpay_test/features/posts/model/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc(this.repository) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<AddPost>(_onAddPost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await repository.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
  try {
    String? mediaUrl;
    String? thumbnailUrl;

    // Upload video/image
    if (event.link != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child('${DateTime.now().millisecondsSinceEpoch}.${event.video ? 'mp4' : 'jpg'}');

      await ref.putFile(event.link!);
      mediaUrl = await ref.getDownloadURL();
    }

    // Upload thumbnail if any
    if (event.thumbnail != null) {
      final thumbRef = FirebaseStorage.instance
          .ref()
          .child('posts/thumbnails')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await thumbRef.putFile(event.thumbnail!);
      thumbnailUrl = await thumbRef.getDownloadURL();
    }

    final post = PostModel(
      id: event.id,
      username: event.username,
      description: event.description,
      link: mediaUrl,
      thumbnail: thumbnailUrl,
      video: event.video,
      noMedia: event.noMedia,
      userId: event.userId,
      timestamp: event.timestamp,
    );

    await repository.addPost(post);
    emit(PostAdded());
    add(LoadPosts());
  } catch (e) {
    emit(PostError(e.toString()));
  }
}

}
