import 'package:flutter/material.dart';

class ArchieveScrean extends StatelessWidget {
  const ArchieveScrean({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
              'archieved Tasks'
          ),
        ],
      ),
    );
  }
}
