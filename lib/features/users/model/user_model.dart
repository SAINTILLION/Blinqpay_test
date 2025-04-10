class UserModel {
  final String id;
  final String username;
  final String bio;
  final String photo;
  final String userId;

  UserModel({
    required this.id,
    required this.username,
    required this.bio,
    required this.photo,
    required this.userId,
  });

  factory UserModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      bio: data['bio'] ?? '',
      photo: data['photo'],
      userId: data['userId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'bio': bio,
      'photo': photo,
    };
  }
}
