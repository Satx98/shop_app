import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Loading...',
              textAlign: TextAlign.center,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
