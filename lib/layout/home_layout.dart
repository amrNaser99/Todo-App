import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/componends/componends.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/app_cubit.dart';
import 'package:todo/shared/cubit/states.dart';


class HomeScrean extends StatelessWidget {

  late var scaffoldKey = GlobalKey<ScaffoldState>();
  late var formKey = GlobalKey<FormState>();

  late var titleController = TextEditingController();
  late var timeController = TextEditingController();
  late var dateController = TextEditingController();

  HomeScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state)
        {
          if(state is AppInsertDatabaseState){
            }
        },
        builder: (BuildContext context,AppStates state) {
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
           key: scaffoldKey,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
            ),
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottonSheatShow) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      context: context,
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                  // cubit.insertToDatabase(
                  //   title: titleController.text,
                  //   date: dateController.text,
                  //   time: timeController.text,
                  // ).then((value) {
                  //   cubit.getDataFromDataBase(cubit.database).then((value) {
                  //
                  //     Navigator.pop(context);
                  //       cubit.tasks = value;
                  //       print(cubit.tasks);
                  //
                  //   });
                  // });
                }
              } else {
                scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              labelText: 'Task Title',
                              prefixIcon: Icons.title,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultTextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Time Must Not Be Empty';
                                }
                                return null;
                              },
                              labelText: 'Task time',
                              prefixIcon: Icons.watch_later_outlined,
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  print(value?.format(context));
                                  timeController.text =
                                      value!.format(context).toString();
                                  print(timeController.text);
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultTextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date Must Not Be Empty';
                                }
                              },
                              labelText: 'Task Date',
                              prefixIcon: Icons.calendar_today,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse("2022-05-03"),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                  print(dateController.text);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0).closed.then((value)
                {
                  cubit.changeBottomCheet(isShow: false, icon: Icons.edit);

                }) ;
                cubit.changeBottomCheet(isShow: true, icon: Icons.add);



                // isBottonSheatShow = true;
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {

                cubit.changeIndex(index);

              },


              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New Task'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ]),
          body: ConditionalBuilder(
              condition: state is! AppGetDatabasLoadingState,
              builder: (context) => cubit.screans[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator())),


          );
        },

      ),
    );
  }



}
  
