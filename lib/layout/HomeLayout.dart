import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/Components/component.dart';
import 'package:todo/Moudel/Archived.dart';
import 'package:todo/Moudel/Done.dart';
import 'package:todo/Moudel/Task.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
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
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  late String date;

  late Database db;
  IconData fabicon = Icons.edit;

  bool isBottomSheetShow = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formdKey = GlobalKey<FormState>();

  @override
  void initState() {
    createDateBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          title[currentstate],
        ),
      ),
      body: screen[currentstate],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShow) {
            if (formdKey.currentState!.validate()) {
              insertDataBase(
                title:titleController.text ,
                data: dateController.text,
                time: timeController.text,
              ).then((onValue){

              }).catchError((onError){


              });
              Navigator.pop(context);
              setState(() {
                fabicon = Icons.edit;
              });
              isBottomSheetShow = false;
            }
          } else {
         final bottomSheet =   scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formdKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      defaultFormField(
                          controler: titleController,
                          type: TextInputType.text,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'title must not be empty';
                            }
                          },
                          prefix: Icons.title,
                          lable: 'Task Title'),
                      SizedBox(height: 15.0),
                      defaultFormField(
                          controler: timeController,
                          type: TextInputType.datetime,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'datetime must not be empty';
                            }
                          },
                          click: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((onValue) {
                              timeController.text =
                                  onValue!.format(context).toString();
                            });
                          },
                          prefix: Icons.watch_later_outlined,
                          lable: 'Task Time'),
                      SizedBox(height: 15.0),
                      defaultFormField(
                          controler: dateController,
                          type: TextInputType.datetime,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Date must not be empty';
                            }
                          },
                          click: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2200),
                            ).then((onValue) {
                              dateController.text =
                                  DateFormat.yMMMd().format(onValue!);
                            });
                          },
                          prefix: Icons.calendar_today_outlined,
                          lable: 'Task Time')
                    ]),
                  ),
                ),
              ),
           elevation: 15.0
            );
            setState(() {
              fabicon = Icons.add;
            });
            bottomSheet?.closed.then((value) {
              setState(() {
                isBottomSheetShow = false;
                fabicon = Icons.edit;
              });
            });
            isBottomSheetShow = true;
          }
        },
        child: Icon(fabicon),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentstate,
          onTap: (index) {
            setState(() {
              currentstate = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline), label: 'Done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined), label: 'Archived'),
          ]),
    );
  }

  Future<String> getName() async {
    return 'diaa helmy ';
  }

  Future createDateBase() async {
    db = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database create');
        db
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT , status TEXT)')
            .then((value) {})
            .catchError((onError) {
          print('error ${onError.toString()}');
        });
      },
      onOpen: (db) {
        print('open db');
      },
    );
  }

  Future insertDataBase({
    required String title,
    required String data,
    required String time,


  }) async {
    return await db.transaction((action) async {
      action
          .rawInsert(
              'INSERT INTO task (title,data,time,status)VALUES("$title" ,"$data","$time","new")')
          .then((onValue) {
        print('inset$onValue');
      }).catchError((onError) {
        print('error ${onError.toString()}');
      });
      return null;
    });
  }
}
