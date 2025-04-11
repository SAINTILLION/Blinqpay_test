import 'dart:io';

abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String username;
  final String bio;
  final File? photo; // New: include avatar image file
  final String userId;

  AddUser({
    required this.name,
    required this.username,
    required this.bio,
    this.photo,
    required this.userId
  });
}