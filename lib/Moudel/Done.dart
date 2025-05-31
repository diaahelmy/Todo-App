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
        var done = AppCubit.get(context).done;
        return listTaskBuilder(tasks: done);
      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
