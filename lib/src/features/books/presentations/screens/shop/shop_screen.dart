import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/others/dynamic_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget{
  final ScrollController scrollController;

  const ShopScreen({super.key, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _ShopView();
}

class _ShopView extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.bag),
            const SizedBox(width: 8),
            Text("Library", style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: Text("Welcome Shop"),
    );
  }
}