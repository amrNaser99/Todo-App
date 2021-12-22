import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/componends/componends.dart';
import 'package:todo/shared/cubit/app_cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArchievedTasksScrean extends StatelessWidget {
  const ArchievedTasksScrean({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {
      },
      builder: (context,state){
        var tasks = AppCubit.get(context).ArchivedTasks;

        return taskBuilder(tasks: tasks);
      },
    );
  }
}
