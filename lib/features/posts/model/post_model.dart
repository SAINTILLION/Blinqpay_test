import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String username;
  final String description;
  final String? link;       // media url (image/video)
  final String? thumbnail;  // optional thumbnail
  final bool video;
  final bool noMedia;
  final String userId;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.username,
    required this.description,
    this.link,
    this.thumbnail,
    required this.video,
    required this.noMedia,
    required this.userId,
    required this.timestamp,
  });

  factory PostModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      username: data['username'],
      description: data['description'],
      link: data['link'],
      thumbnail: data['thumbnail'],
      video: data['video'],
      noMedia: data['no_media'],
      userId: data['user_id'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'description': description,
      'link': link,
      'thumbnail': thumbnail,
      'video': video,
      'no_media': noMedia,
      'user_id': userId,
      'timestamp': timestamp,
    };
  }
}
