import 'package:flutter/material.dart';
import 'package:movies_app/core/constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Image.asset(ImagesStrings.errrorImage)),
      ),
    );
  }
}
