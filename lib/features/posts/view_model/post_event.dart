import 'dart:io';

abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final String id;
  final String username;
  final String description;
  final File? link; //for storing the video
  final File? thumbnail;
  final bool video;
  final bool noMedia;
  final String userId;
  final DateTime timestamp;

  AddPost({
    required this.id,
    required this.username,
    required this.description,
    required this.link,
    required this.thumbnail,
    required this.userId,
    required this.noMedia,
    required this.video,
    required this.timestamp
  });
}
