import 'package:blinqpay_test/features/posts/view/addpost_screen.dart';
import 'package:blinqpay_test/features/posts/view/post_screen.dart';
import 'package:blinqpay_test/features/users/view/user_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String posts = '/posts';
  static const String users = '/users';
  static const String addPost = '/addPost';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case posts:
        return MaterialPageRoute(builder: (_) => PostsScreen());
      case users:
        return MaterialPageRoute(builder: (_) => UsersScreen());
      case addPost:
      return MaterialPageRoute(builder: (_) => AddPostScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
