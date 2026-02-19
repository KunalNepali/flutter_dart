//import 'package:currency_converter/pages/currency_converter_material_page.dart';
import 'package:flutter/material.dart';
import 'currency_converter_material_page.dart';

void main() {
  runApp(const MyApp());
}

//Widgets types:
// 1. Stateless Widget - in terms of UI related stuffs
// 2. Stateful Widget  - in terms of UI related stuffs
// 3. Inherited Widget - for some other stuffs

// State Less Widget means state does not change, i.e. not changable state, immutable
// State ful Widget means state does change, i.e. changable state, mutable
// We just made sure, app is divided in to smaller pieces

//1. Material Design: Google's Design
//2. Cupertino Design: Apple's Design
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  }); // Optionally taking from constructor and giving to widgets
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CurrencyConverterMaterialPage());
  }
}
