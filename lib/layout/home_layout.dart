import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Module/archieve/archieve.dart';
import 'package:todo/Module/done/done_screan.dart';
import 'package:todo/Module/new_task/new_task.dart';
import 'package:todo/shared/componends/componends.dart';

class HomeScrean extends StatefulWidget {
  const HomeScrean({Key? key}) : super(key: key);

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  int currentIndex = 0;
  List<String> titles = ['New Task', 'Done Task', 'Archieve'];
  List<Widget> screans = [
    NewTaskScrean(),
    DoneScrean(),
    ArchieveScrean(),
  ];

  late Database database;
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottonSheat = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    creatDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
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
          if (isBottonSheat) {
            Navigator.pop(context);
            setState(() {
              fabIcon = Icons.edit;
            });
            isBottonSheat = false;
          } else {
            setState(() {
              fabIcon = Icons.add;

              ScaffoldKey.currentState?.showBottomSheet((context) => Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(
                      20.0,
                    ),
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
                        SizedBox(
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
                                .then((value)
                                {
                                  print(value?.format(context));
                                  timeController.text =  value!.format(context).toString();
                                  print(timeController.text);
                            });
                          },
                        ),
                      ],
                    ),
                  ));
            });
            isBottonSheat = true;
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
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("first task","15/9","12:04","new")')
          .then((value) {
        print('$value is inserting successfully');
      }).catchError((error) {
        print('Error when Insert new raw Record ${error.toString()}');
      });
      return null;
    });
  }
}
