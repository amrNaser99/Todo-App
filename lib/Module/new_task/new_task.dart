import 'package:flutter/material.dart';
import 'package:todo/shared/componends/contants.dart';

class NewTaskScrean extends StatelessWidget {
  const NewTaskScrean({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Text(
                    '04:00 PM'
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Title',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Task Date',

                  ),
                ],
              ),
            ],
          ),
        ),
        separatorBuilder: (context,index) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: tasks!.length);
  }
}
