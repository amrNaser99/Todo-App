import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Module/archieve/archieve.dart';
import 'package:todo/Module/done/done_screan.dart';
import 'package:todo/Module/new_task/new_task.dart';
import 'package:todo/shared/componends/componends.dart';
import 'package:todo/shared/componends/contants.dart';
import 'package:intl/intl.dart';

class HomeScrean extends StatefulWidget {
  const HomeScrean({Key? key}) : super(key: key);

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  int currentIndex = 0;
  List<String> titles = ['New Task', 'Done Task', 'Archieve'];
  List<Widget> screans = [
    const NewTaskScrean(),
    const DoneScrean(),
    const ArchieveScrean(),
  ];

  late Database database;
  late var scaffoldKey = GlobalKey<ScaffoldState>();
  late var formKey = GlobalKey<FormState>();
  bool isBottonSheatShow = false;
  IconData fabIcon = Icons.edit;
  late var titleController = TextEditingController();
  late var timeController = TextEditingController();
  late var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    creatDatabase();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        title: Text(
          titles[currentIndex],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottonSheatShow)
          {
            if (formKey.currentState!.validate()) {

              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottonSheatShow = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });

            }
          } else {
            scaffoldKey.currentState?.showBottomSheet((context) => Container(
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
                          print(DateFormat.yMMMd().format(value!));
                          dateController.text = DateFormat.yMMMd().format(value);
                          print(dateController.text);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
                elevation: 20.0);

            setState(() {
              fabIcon = Icons.add;
            });
            isBottonSheatShow = true;
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
              print(currentIndex);
            });
          },
          currentIndex: currentIndex,
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
      body: screans[currentIndex],
    );
  }

  void creatDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error is ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database).then((value)
        {
          tasks = value ;
          print(tasks);
        });

        print('database opened');
      },
    );
  }

  Future insertToDatabase(
      {
        required String title,
        required String time,
        required String date})
  {
    return database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value is inserting successfully');
      }).catchError((error) {
        print('Error when Insert new raw Record ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async
  {
     return await database.rawQuery("SELECT * FROM tasks");
  }
}
