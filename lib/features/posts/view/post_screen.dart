import 'package:blinqpay_test/shared/route.dart';
import 'package:blinqpay_test/shared/theme/color_theme/color_theme_bloc.dart';
import 'package:blinqpay_test/shared/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final List<GlobalKey<_PostTileState>> _postKeys =
      List.generate(10, (_) => GlobalKey<_PostTileState>());

  int? currentlyPlayingIndex;

  void _onVisible(int index) {
    if (currentlyPlayingIndex != index) {
      for (int i = 0; i < _postKeys.length; i++) {
        if (i == index) {
          _postKeys[i].currentState?.play();
        } else {
          _postKeys[i].currentState?.pause();
        }
      }
      currentlyPlayingIndex = index;
    }
  }

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text("Posts"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: ListView.builder(
        itemCount: _postKeys.length,
        itemBuilder: (context, index) {
          return PostTile(
            key: _postKeys[index],
            index: index,
            onVisible: _onVisible,
            no_media: false,
            video: false,
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          );
        },
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final String videoUrl;
  final int index;
  final void Function(int) onVisible;
  final bool no_media;
  final bool video;

  const PostTile({
    super.key,
    required this.videoUrl,
    required this.index,
    required this.onVisible,
    required this.no_media,
    required this.video,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video player if the post contains a video.
    if (!widget.no_media && widget.video) {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          _controller.setLooping(true);
          _controller.setVolume(0.0); // Mute for autoplay
          setState(() {
            _initialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    if (!widget.no_media && widget.video) {
      _controller.dispose();
    }
    super.dispose();
  }

  void play() {
    if (_initialized && !_controller.value.isPlaying) {
      _controller.play();
    }
  }

  void pause() {
    if (_initialized && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('post_tile_${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.9) {
          widget.onVisible(widget.index);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 2),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head-section of the post tile
            Row(
              children: const [
                CircleAvatar(),
                SizedBox(width: 10),
                Text("Hello"),
                Spacer(),
                Text("Nov"),
                Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 5),
            // Conditionally render content based on no_media and video flags
            if (!widget.no_media) ...[
              if (widget.video && _initialized) 
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              if (!widget.video) 
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Image.network(
                    'https://images.pexels.com/photos/2449452/pexels-photo-2449452.jpeg?auto=compress&cs=tinysrgb&w=600', // Use a placeholder image or image URL
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
            if (widget.no_media) ...[
              const Text("This is a text-only post."),
            ],
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(Icons.favorite_outline_outlined),
                      Text("28 likes", style: TextThemes.headline1),
                    ],
                  ),
                  SizedBox(width:4),
                  Column(
                    children: [
                      Icon(Icons.comment_outlined),
                      Text("12 comments", style: TextThemes.headline1),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.share_outlined)
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
