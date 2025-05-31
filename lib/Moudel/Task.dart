import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Components/component.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

import '../Components/contants.dart';

class Task extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state)
      {
        var task = AppCubit.get(context).task;
        return
          ListView.separated(itemBuilder: (context,index) =>
              buildTaskItem(task[index])
              , separatorBuilder: (context,index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ), itemCount: task.length);
      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
// buildTaskItem(time: "time", data: "data", note: "note")