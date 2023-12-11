import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_switch.g.dart';

@riverpod
class ThemeSwitch extends _$ThemeSwitch {
  @override
  Brightness build() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  void update(Brightness theme) {
    state = theme;
  }
}
