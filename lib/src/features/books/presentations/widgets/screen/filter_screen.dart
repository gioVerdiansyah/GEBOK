import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/list/dropdown_expanded.dart';

class FilterScreen extends StatefulWidget{
  const FilterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilterView();
}

class _FilterView extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _languageDropdown()
          ],
        ),
      )
    );
  }

  Widget _buildHeader(){
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 1))),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Filter", style: TextStyle(fontSize: 16),),
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _languageDropdown(){
    return DropdownExpanded(
      languages: [
        'All',
        'English',
        'Indonesia',
        'Español',
        'Čeština',
        'Dansk',
        'Deutsch',
        'Français',
      ],
    );
  }
}