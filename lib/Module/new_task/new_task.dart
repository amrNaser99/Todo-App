import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/componends/componends.dart';
import 'package:todo/shared/cubit/app_cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class NewTaskScrean extends StatelessWidget {
  const NewTaskScrean({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    var tasks = AppCubit.get(context).tasks;

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return ListView.separated(
            itemBuilder: (context,index) => buildTaskItem(tasks![index]),
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
      },
    );
  }
}
