import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/componends/componends.dart';
import 'package:todo/shared/cubit/app_cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasksScrean extends StatelessWidget {
  const DoneTasksScrean({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {
      },
      builder: (context,state){
        var tasks = AppCubit.get(context).DoneTasks;

        return taskBuilder(
            tasks: tasks
        );
      },
    );
  }
}
