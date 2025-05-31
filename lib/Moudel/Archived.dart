import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Components/component.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Archived extends StatelessWidget {
  const Archived ({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, AppStates state)
      {
        var archived = AppCubit.get(context).archived;
        return
          listTaskBuilder(tasks: archived);
      },
      listener: (BuildContext context, AppStates state) {  },
    );
   }
}
