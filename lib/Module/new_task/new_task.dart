import 'package:flutter/material.dart';

class NewTaskScrean extends StatelessWidget {
  const NewTaskScrean({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New Task'
          ),
        ],
      ),
    );
  }
}
