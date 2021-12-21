import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Module/archieve/archieve.dart';
import 'package:todo/Module/done/done_screan.dart';
import 'package:todo/Module/new_task/new_task.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = ['New Task', 'Done Task', 'Archieve'];
  List<Widget> screans = [
    const NewTaskScrean(),
    const DoneScrean(),
    const ArchieveScrean(),
  ];

  void changeIndex(int index){
    currentIndex = index ;
    emit(AppChangeBootomNavBarState());
  }

  late Database database;
  List<Map>? tasks =[];

  void creatDatabase()  {

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
        getDataFromDataBase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDatabaseState());


        });
        print('data received From Database successfully');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    }
    );
  }

  insertToDatabase(
      {
        required BuildContext context,
        required String title,
        required String time,
        required String date,
      }
        )
  async {
     await database.transaction((txn) async{
       txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value is inserting successfully');
        emit(AppInsertDatabaseState());
        Navigator.pop(context);
        getDataFromDataBase(database).then((value)
        {
          tasks = value;
            print('this is new $tasks');
            emit(AppGetDatabaseState());

        });
        }).catchError((error) {
        print('Error when Insert new raw Record ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    emit(AppGetDatabasLoadingState());

    return await database.rawQuery("SELECT * FROM tasks");
  }


  bool isBottonSheatShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomCheet(
      {required bool isShow,
        required IconData icon})
  {
    isBottonSheatShow = isShow ;
    fabIcon = icon;

    emit(AppChangeBootomNavBarState());
  }

}
