import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:blinqpay_test/features/posts/view/post_screen.dart';
import 'package:blinqpay_test/features/users/view/user_screen.dart';
import 'package:blinqpay_test/firebase_options.dart';
import 'package:blinqpay_test/shared/route.dart';
import 'package:blinqpay_test/shared/theme/app_theme.dart';
import 'package:blinqpay_test/shared/theme/color_theme/color_theme_bloc.dart';
import 'package:blinqpay_test/shared/theme/color_theme/color_theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>( // Specify the cubit type
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BlinqPost',
            themeMode: themeState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(builder: (_) => const HomePage());
              }
              return AppRoutes.generateRoute(settings); // your existing logic
            },

          );
        },
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _pages = [
   PostsScreen(),
   UsersScreen()
  ];

  late final AnimationController _pageController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageTransition(Widget child) {
    _pageController.reset();
    _pageController.forward();
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _pageController,
        child: child,
      ),
    );
  }

  Widget _buildCurvyIconWithLabel(int index, IconData icon, String label) {
    bool isActive = index == _currentIndex;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: isActive ? 0.6 : 0.8,
        end: isActive ? 1.0 : 0.8,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final icons = [Icons.feed, Icons.person];
    final labels = ['Posts', 'User'];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => _buildPageTransition(child),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: icons.length,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        tabBuilder: (index, isActive) {
          return _buildCurvyIconWithLabel(index, icons[index], labels[index]);
        },
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
