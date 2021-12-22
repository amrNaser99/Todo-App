import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Module/archieved-tasks/archieved_tasks_screan.dart';
import 'package:todo/Module/done_tasks/done_screan.dart';
import 'package:todo/Module/new_task/new_task.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = ['New Task', 'Done Task', 'Archieve'];
  List<Widget> screans = [
    const NewTaskScrean(),
    const DoneTasksScrean(),
    const ArchievedTasksScrean(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBootomNavBarState());
  }

  late Database database;
  List<Map> NewTasks = [];
  List<Map> DoneTasks = [];
  List<Map> ArchivedTasks = [];

  void creatDatabase() {
    openDatabase(
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
        getDataFromDataBase(database);
        print('data received From Database successfully');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required BuildContext context,
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value is inserting successfully');
        emit(AppInsertDatabaseState());
        Navigator.pop(context);
        getDataFromDataBase(database);
      }).catchError((error) {
        print('Error when Insert new raw Record ${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    NewTasks = [];
    DoneTasks = [];
    ArchivedTasks = [];

    emit(AppGetDatabasLoadingState());

    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          NewTasks.add(element);
        } else if (element['status'] == 'done') {
          DoneTasks.add(element);
        } else if (element['status'] == 'archived') {
          ArchivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  // Update some record
  void updateData({
    required String status,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }


  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottonSheatShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomCheet({required bool isShow, required IconData icon}) {
    isBottonSheatShow = isShow;
    fabIcon = icon;

    emit(AppChangeBootomNavBarState());
  }
}
