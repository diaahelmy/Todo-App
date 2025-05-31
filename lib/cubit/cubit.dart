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
        getDataBase(db).then((onValue) {
          task = onValue;

          print(task);
          emit(AppGetDataBase());
        }).catchError((onError) {
          print('error in get data${onError.toString()}');
        });
        print('db open ');
      },
    ).then((onValue) {
      db = onValue;
      emit(AppCreateDataBase());
    });
  }

 insertDataBase(
      {required String title,
      required String data,
      required String time,
      required String subTitle})async {
  await db.transaction((action) async {
      action
          .rawInsert(
              'INSERT INTO tasks (title,data,time,subtitle,status)VALUES("$title" ,"$data","$time","$subTitle","new")')
          .then((onValue) {
        print('inset SUCCESSFully $onValue');
        emit(AppInsertDataBase());

        getDataBase(db).then((value) {
          task = value;

          print("hi diaa this work $task");
          emit(AppGetDataBase());
        });

      }).catchError((onError) {
        print('error in insert database${onError.toString()}');
      });
     return null ;
    });
  }

  Future getDataBase(db) async {
    emit(AppGetLoadingScreen());
    List<Map> tasks = await db.rawQuery('SELECT * FROM tasks');
    return tasks;
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
