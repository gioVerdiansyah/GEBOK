import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget{
  final ScrollController scrollController;

  const FavoriteScreen({super.key, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _LibraryView();
}

class _LibraryView extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Welcome Favorite"),
    );
  }
}