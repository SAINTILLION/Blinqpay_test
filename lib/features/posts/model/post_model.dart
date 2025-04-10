enum PostType { text, image, video }

class PostModel {
  final String id;
  final String username;
  final String description;
  final String? link;
  final String thumbnail;
  final bool video;
  final bool noMedia;
  final String userId;
  final DateTime timestamp;


  PostModel({
    required this.id,
    required this.description,
    required this.username,
    required this.userId,
    required this.link,
    required this.thumbnail,
    required this.video,
    required this.noMedia,
    required this.timestamp,
  });

  PostType get type {
    if (noMedia) return PostType.text;
    if (video) return PostType.video;
    return PostType.image;
  }

  factory PostModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      description: data['description'] ?? '',
      thumbnail: data['thumbnail'],
      noMedia: data['no_media'] ?? true,
      video: data['video'] ?? false,
      userId: data['user_id'] ?? '',
      timestamp: data['timestamp'] ?? DateTime.now(),
      username: data['username'],
      link: data['link']

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'link': link,
      'no_media': noMedia,
      'video': video,
      'user_id': userId,
      'username': username,
      'thumnail': thumbnail,
      "timestamp" : timestamp
    };
  }
}
