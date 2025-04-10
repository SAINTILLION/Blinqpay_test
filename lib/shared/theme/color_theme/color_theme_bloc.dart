import 'package:blinqpay_test/shared/theme/color_theme/color_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    emit(
      state.themeMode == ThemeMode.light
          ? ThemeState(themeMode: ThemeMode.dark)
          : ThemeState(themeMode: ThemeMode.light),
    );
  }
}
