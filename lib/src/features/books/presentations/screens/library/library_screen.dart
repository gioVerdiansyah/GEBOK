import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/others/dynamic_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget{
  final ScrollController scrollController;

  const LibraryScreen({super.key, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _LibraryView();
}

class _LibraryView extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.book),
            const SizedBox(width: 8),
            Text("Library", style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: Text("Welcome Library"),
    );
  }
}