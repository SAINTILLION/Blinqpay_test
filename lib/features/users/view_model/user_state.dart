import 'package:blinqpay_test/features/users/model/user_model.dart';


abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserAdded extends UserState {}
