import 'package:flutter/cupertino.dart';

class Done extends StatelessWidget {
  const Done({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text('Done Task',style:TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),),
    );

  }
}
