import 'package:flutter/material.dart';

class DoneScrean extends StatelessWidget {
  const DoneScrean({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Done'
          ),
        ],
      ),
    );
  }
}
