import 'package:demo/utils/dimensions.dart';
import 'package:flutter/material.dart';

const ReponsiveLayout extends StatelessWidget {
  const ReponsiveLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth > webScreenSize) {

        }
      },
    );
  }
}