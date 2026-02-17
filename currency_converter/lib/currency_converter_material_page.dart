import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatelessWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        // color: Colors.black,
        width: 2.0,
        style: BorderStyle.solid,
        // strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.circular(5),
    );
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '0',
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),

            //padding
            //constainer
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Please enter the amount in USD',
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
