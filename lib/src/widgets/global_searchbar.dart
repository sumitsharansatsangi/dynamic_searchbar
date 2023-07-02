import 'package:dynamic_searchbar/src/models/search_theme_data.dart';
import 'package:flutter/cupertino.dart';

/// When [GlobalSearchbar] is wrapped in a widget, its style and localization
/// can be customized.
///
/// Set the settings you want to customize in [searchThemeData].
class GlobalSearchbar extends StatefulWidget {
  const GlobalSearchbar({
    Key? key,
    required this.child,
    required this.searchThemeData,
  }) : super(key: key);

  final Widget child;
  final SearchThemeData searchThemeData;

  @override
  State<GlobalSearchbar> createState() => _GlobalSearchbarState();

  // ignore: library_private_types_in_public_api
  static _SearchBar? of(BuildContext context) => _SearchBar.of(context);
}

class _GlobalSearchbarState extends State<GlobalSearchbar> {
  @override
  Widget build(BuildContext context) {
    return _SearchBar(
      themeData: widget.searchThemeData,
      child: widget.child,
    );
  }
}

class _SearchBar extends InheritedWidget {
  const _SearchBar({
    required this.themeData,
    required super.child,
  });

  static _SearchBar? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SearchBar>();

  final SearchThemeData themeData;

  @override
  bool updateShouldNotify(_SearchBar oldWidget) {
    return oldWidget.themeData != themeData;
  }
}
