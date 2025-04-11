import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../users/view_model/user_bloc.dart';
import '../../users/view_model/user_event.dart';
import '../../users/view_model/user_state.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImageFromGallery() async {
  final status = await Permission.photos.request();

  if (status.isGranted) {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  } else if (status.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Permission permanently denied. Please enable it from settings."),
        action: SnackBarAction(
          label: "Settings",
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Permission denied")),
    );
  }
}


  void _saveUser() {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final bio = bioController.text.trim();

    if (name.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and username are required"))
      );
      return;
    }

    context.read<UserBloc>().add(
          AddUser(
            userId: "",
            name: name,
            username: username,
            bio: bio,
            photo: _selectedImage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add user'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserAdded) {
            Navigator.pop(context); // Go back after saving
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const NetworkImage(
                              'https://images.pexels.com/photos/2449452/pexels-photo-2449452.jpeg?auto=compress&cs=tinysrgb&w=600',
                            ) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildTextField(controller: nameController, label: "Enter your full name"),
              buildTextField(controller: usernameController, label: "Enter your username"),
              buildTextField(controller: bioController, label: 'Add Bio', maxLines: null),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    String? label,
    var maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
