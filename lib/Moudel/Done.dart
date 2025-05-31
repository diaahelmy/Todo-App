import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Components/component.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Done extends StatelessWidget {
  const Done({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state)
      {
        var task = AppCubit.get(context).done;
        return
          ListView.separated(itemBuilder: (context,index) =>
              buildTaskItem(task[index],context)
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
