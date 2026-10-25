import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

class SvgCacheHelper {
  static const List<String> _navIcons = [
    'assets/image/icon svg/home.svg',
    'assets/image/icon svg/electric.svg',
    'assets/image/icon svg/bell.svg',
    'assets/image/icon svg/profile.svg',
    'assets/image/icon svg/suitcase.svg',
  ];

  /// Pre-parses and caches SVG pictures into memory in the background
  /// so they render instantly with 0ms UI-thread parsing jank when
  /// navigation bars build.
  static void precacheNavIcons() {
    for (final path in _navIcons) {
      unawaited(
        vg.loadPicture(SvgAssetLoader(path), null),
      );
    }
  }
}
