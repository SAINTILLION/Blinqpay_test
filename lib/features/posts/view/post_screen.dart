import 'package:blinqpay_test/core/route.dart';
import 'package:blinqpay_test/core/theme/color_theme/color_theme_bloc.dart';
import 'package:blinqpay_test/core/theme/text_theme.dart';
import 'package:blinqpay_test/features/posts/model/post_model.dart';
import 'package:blinqpay_test/features/posts/view_model/post_bloc.dart';
import 'package:blinqpay_test/features/posts/view_model/post_event.dart';
import 'package:blinqpay_test/features/posts/view_model/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final List<GlobalKey<_PostTileState>> _postKeys = [];
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
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPosts()); // Fetch posts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPost);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text("Posts"),
        centerTitle: true,
        shadowColor: Colors.grey,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            final posts = state.posts;
            _postKeys.clear();
            _postKeys.addAll(List.generate(posts.length, (_) => GlobalKey<_PostTileState>()));

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final PostModel post = posts[index];
                return PostTile(
                  key: _postKeys[index],
                  index: index,
                  onVisible: _onVisible,
                  no_media: post.noMedia,
                  video: post.video,
                  videoUrl: post.link,
                  imageUrl: !post.video ? post.link : null,
                  username: post.username,
                  date: post.timestamp,
                  description: post.description,
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No posts yet"));
          }
        },
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final String? videoUrl;
  final String? imageUrl;
  final int index;
  final void Function(int) onVisible;
  final bool no_media;
  final bool video;
  final String username;
  final DateTime date;
  final String description;

  const PostTile({
    super.key,
    required this.index,
    required this.onVisible,
    required this.no_media,
    required this.video,
    this.videoUrl,
    this.imageUrl,
    required this.username,
    required this.date,
    required this.description,
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
    if (!widget.no_media && widget.video && widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          _controller.setLooping(true);
          _controller.setVolume(0.0);
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
        margin: const EdgeInsets.only(bottom: 2),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Row(
              children: [
                const CircleAvatar(),
                const SizedBox(width: 10),
                Text(
                  widget.username,
                  style: TextThemes.headline1.copyWith(fontSize: 12),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM d, yyyy').format(widget.date),
                  style: TextThemes.headline1.copyWith(fontSize: 12),
                ),
                const Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 5),

            /// Media
            if (!widget.no_media) ...[
              if (widget.video && _initialized)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              if (!widget.video && widget.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.network(
                    widget.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],

            /// Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.description),
            ),

            /// Likes/Comments/Share
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.favorite_outline_outlined),
                      Text("28 likes", style: TextThemes.headline1),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const Icon(Icons.comment_outlined),
                      Text("12 comments", style: TextThemes.headline1),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.share_outlined)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
