import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/utils/book_query_handler.dart';
import 'package:book_shelf/src/shared/utils/book_subject_maker.dart';
import 'package:book_shelf/src/shared/widgets/others/dynamic_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/screen/search_screen.dart';

class PickGenreScreen extends StatefulWidget{
  const PickGenreScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PickGenreView();
}

class _PickGenreView extends State<PickGenreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondary,
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Text("Genre-genre", style: TextStyle(color: Colors.black, fontSize: 18),),
        titleAlignment: Alignment.centerLeft,
        trailingWidgets: [
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black54)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: BookSubjectPicker.subjects.map((genre) => _buildGenre(genre)).toList(),
          ),
        ),
      ),
    );
  }


  Widget _buildGenre(String genre){
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: ColorConstant.secondary,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: SearchScreen(titleSearch: genre, query: BookQuery(generic: genre)),
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(genre, style: TextStyle(color: ColorConstant.primary, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}