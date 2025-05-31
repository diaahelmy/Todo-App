import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Components/component.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';


class Task extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state)
      {
        var task = AppCubit.get(context).task;
        return listTaskBuilder(tasks: task);



      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
// buildTaskItem(time: "time", data: "data", note: "note")