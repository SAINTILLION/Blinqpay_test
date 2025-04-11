import 'package:blinqpay_test/shared/route.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPost);
        },
        backgroundColor: Colors.blue, // Blue background
        child: Icon(
          Icons.add, // Plus icon
          color: Colors.white, // White color for the icon
          size: 30, // Adjust the size of the icon
        ),
      ),
    );
  }
}