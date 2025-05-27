import 'package:flutter/cupertino.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('New Task',style:TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
      ),),
    );
  }
}
