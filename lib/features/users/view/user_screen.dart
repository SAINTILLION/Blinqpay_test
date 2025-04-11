import 'package:blinqpay_test/core/route.dart';
import 'package:blinqpay_test/core/theme/color_theme/color_theme_bloc.dart';
import 'package:blinqpay_test/features/users/model/user_model.dart';
import 'package:blinqpay_test/features/users/view_model/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addUser);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text("Users"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: userBloc.repository.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ),
                duration: Duration(milliseconds: 500 + (index * 100)),
                curve: Curves.easeOut,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: offset * MediaQuery.of(context).size.width,
                    child: child,
                  );
                },
                child: userTile(user),
              );
            },
          );
        },
      ),
    );
  }

  Widget userTile(UserModel user) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage: user.photo != null
            ? NetworkImage(user.photo!)
            : const AssetImage('assets/image/pexels-thatguycraig000-2449452.jpg'),
      ),
      title: Text(user.name),
      subtitle: Text(user.bio),
      trailing: Text(user.username),
    ),
  );
}

}
