import 'package:blinqpay_test/features/users/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../data/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

 Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
  try {
    String? photo;

    if (event.photo != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('photos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg'); //store based on the time uploaded

      await ref.putFile(event.photo!);
      photo = await ref.getDownloadURL();
    }

    final user = UserModel(
      id: '',
      name: event.name,
      userId: event.userId,
      bio: event.bio,
      username: event.username, // using username as email placeholder
      photo: photo,
    );

    await repository.addUser(user);
    emit(UserAdded());
    add(LoadUsers());
  } catch (e) {
    emit(UserError(e.toString()));
  }
}
}
