import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/Components/component.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

import '../Components/contants.dart';

class HomeLayout extends StatelessWidget {

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var subTitleController = TextEditingController();

  late String date;



  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formdKey = GlobalKey<FormState>();


  // @override
  // void initState() {
  // createDateBase();
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDateBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDataBase){
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentstate],
              ),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetLoadingScreen,
              builder: (context) => cubit.screen[cubit.currentstate],
              fallback: (context) =>
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formdKey.currentState!.validate()) {
                    cubit.insertDataBase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        subtitle: subTitleController.text);
                    //     .then((onValue) {
                    //   cubit.getDataBase( cubit.db).then((onValue) {

                        cubit.changeIcon(isShow: false, icon: Icons.edit);
                    //   }).catchError((onError) {
                    //     print('error$onError');
                    //   });
                    // });
                  }
                } else {
                  final bottomSheet = scaffoldKey.currentState?.showBottomSheet(
                          (context) =>
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                key: formdKey,
                                child:
                                Column(
                                    mainAxisSize: MainAxisSize.min, children: [
                                  defaultFormField(
                                      controler: titleController,
                                      type: TextInputType.text,
                                      validator: (value) {
                                        if (value
                                            .toString()
                                            .isEmpty) {
                                          return 'title must not be empty';
                                        }
                                      },
                                      prefix: Icons.title,
                                      lable: 'Task Title'),
                                  const SizedBox(height: 15.0),
                                  defaultFormField(
                                      controler: subTitleController,
                                      type: TextInputType.text,
                                      validator: (value) {
                                        if (value
                                            .toString()
                                            .isEmpty) {
                                          return 'SubTitle must not be empty';
                                        }
                                      },
                                      prefix: Icons.subtitles,
                                      lable: 'SubTitle'),
                                  SizedBox(height: 15.0),
                                  defaultFormField(
                                      controler: timeController,
                                      type: TextInputType.datetime,
                                      validator: (value) {
                                        if (value
                                            .toString()
                                            .isEmpty) {
                                          return 'datetime must not be empty';
                                        }
                                      },
                                      click: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((onValue) {
                                          timeController.text =
                                              onValue!.format(context)
                                                  .toString();
                                        });
                                      },
                                      prefix: Icons.watch_later_outlined,
                                      lable: 'Task Time'),
                                  SizedBox(height: 15.0),
                                  defaultFormField(
                                      controler: dateController,
                                      type: TextInputType.datetime,
                                      validator: (value) {
                                        if (value
                                            .toString()
                                            .isEmpty) {
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
                                              DateFormat.yMMMd().format(
                                                  onValue!);
                                        });
                                      },
                                      prefix: Icons.calendar_today_outlined,
                                      lable: 'Task Time')
                                ]),
                              ),
                            ),
                          ),
                      elevation: 15.0);
                  // setState(() {
                  cubit.changeIcon(isShow: false, icon: Icons.add);
                  // });
                  bottomSheet?.closed.then((value) {
                    cubit.changeIcon(isShow: false, icon: Icons.edit);
                    // cubit.isBottomSheetShow = false;
                    // setState(() {
                    // fabicon = Icons.edit;
                    // });
                  });
                  cubit.isBottomSheetShow = true;
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentstate,
                onTap: (index) {
                  cubit.changeIndex(index);
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
        },

      ),
    );
  }
}