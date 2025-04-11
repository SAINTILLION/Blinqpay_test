import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../posts/view_model/post_bloc.dart';
import '../../posts/view_model/post_event.dart';
import '../../posts/view_model/post_state.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController contentController = TextEditingController();

  File? _selectedFile;
  String? _fileType;

  Future<bool> _requestPermissions() async {
    final status = await Permission.photos.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedWithSettings();
      openAppSettings();
    } else {
      _showPermissionDeniedMessage();
      openAppSettings();
    }
    return false;
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permission denied')),
    );
  }

  void _showPermissionDeniedWithSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Permission permanently denied. Please enable it in settings.'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    if (await _requestPermissions()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _fileType = 'image';
        });
      }
    }
  }

  Future<void> _pickVideo() async {
    if (await _requestPermissions()) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        final file = File(video.path);
        final sizeInBytes = await file.length();
        final sizeInMB = sizeInBytes / (1024 * 1024);

        if (sizeInMB > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video must be less than 10MB')),
          );
          return;
        }

        setState(() {
          _selectedFile = file;
          _fileType = 'video';
        });
      }
    }
  }

  void _submitPost() {
    final description = contentController.text.trim();

    if (description.isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select media')),
      );
      return;
    }

    context.read<PostBloc>().add(
          AddPost(
            id: '',
            username: 'Anonymous', // Replace with actual user data
            description: description,
            link: _selectedFile,
            thumbnail: null, // optional — generate video thumbnails later
            video: _fileType == 'video',
            noMedia: _selectedFile == null,
            userId: 'mock-user-id', // Replace with actual Firebase user ID
            timestamp: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post submitted!')),
            );
            Navigator.pop(context);
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: contentController,
                maxLines: 6,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Write something...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.image),
                    label: const Text('Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video'),
                  ),
                ],
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _fileType == 'image'
                      ? Image.file(_selectedFile!, height: 200)
                      : const Icon(Icons.videocam, size: 100, color: Colors.blue),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('POST'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
