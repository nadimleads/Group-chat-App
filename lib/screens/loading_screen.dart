import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chat', style: TextStyle(color: Colors.blueAccent)),
            Text('App'),
          ],
        ),
      ),
      body: Center(child: Text('Loading...')),
    );
  }
}
