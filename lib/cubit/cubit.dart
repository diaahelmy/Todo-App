import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/states.dart';

import '../Components/contants.dart';
import '../Moudel/Archived.dart';
import '../Moudel/Done.dart';
import '../Moudel/Task.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database db;
  IconData fabicon = Icons.edit;
  List<Map> task = [];
  List<Map> done = [];
  List<Map> archived = [];

  bool isBottomSheetShow = false;
  int currentstate = 0;

  List<Widget> screen = [
    Task(),
    Done(),
    Archived(),
  ];
  List<String> title = [
    'New Task',
    "Done Task",
    "Archived Task",
  ];

  void changeIndex(int index) {
    currentstate = index;
    emit(AppChangeBottomNavBar());
  }

  void createDateBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database create');
        db
            .execute('CREATE TABLE tasks('
                'id INTEGER PRIMARY KEY,'
                ' title TEXT,'
                ' data TEXT,'
                ' time TEXT,'
                ' subtitle TEXT,'
                ' status TEXT)')
            .then((value) {
          print('table create ');
        }).catchError((onError) {
          print('Error create database ${onError.toString()}');
        });
      },
      onOpen: (db) {
        getDataBase(db);
        print('db open ');
      },
    ).then((onValue) {
      db = onValue;
      emit(AppCreateDataBase());
    });
  }

  insertDataBase(
      {required String title,
      required String date,
      required String time,
      required String subtitle}) async {
    await db.transaction((action) async {
      action
          .rawInsert(
              'INSERT INTO tasks (title,data,time,subtitle,status)VALUES("$title" ,"$date","$time","$subtitle","new")')
          .then((onValue) {
        print('inset SUCCESSFully $onValue');
        emit(AppInsertDataBase());

        getDataBase(db);
      });
      return null;
    });
  }

  void getDataBase(db) {
     task = [];
     done = [];
    archived = [];

    emit(AppGetLoadingScreen());
    db.rawQuery('SELECT * FROM tasks').then((onValue) {
      onValue.forEach((element) {
        if (element['status'] == 'new') {
          task.add(element);
        } else if (element['status'] == 'done') {
          done.add(element);
        } else {
          archived.add(element);
        }
      });
      emit(AppGetDataBase());
    });
  }

  void updateDateBase({required String status, required int id}) {
    db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id']).then((onValue) {
      emit(AppUpdateDataBase());
      getDataBase(db);
    });
  }
  void deleteDataBase({required int id }){
      db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((onValue) {
        emit(AppDeleteDataBase());
        getDataBase(db);
      });;

  }

  void changeIcon({
    required bool isShow,
    required IconData icon,
  }) {
    fabicon = icon;
    isBottomSheetShow = isShow;

    emit(AppChangeItem());
  }
}
