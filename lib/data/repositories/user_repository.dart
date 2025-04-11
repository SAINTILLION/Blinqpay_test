import '../services/user_service.dart';
import '../../features/users/model/user_model.dart';

class UserRepository {
  final UserService userService;

  UserRepository(this.userService);

  Future<List<UserModel>> getUsers() => userService.fetchUsers();
  Future<void> addUser(UserModel user) => userService.addUser(user);
  Stream<List<UserModel>> streamUsers() {
  return userService.streamUsers();
}

}
