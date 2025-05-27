import 'package:flutter/cupertino.dart';

class Archived extends StatelessWidget {
  const Archived ({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text('Archived Task',style:TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),),
    );
   }
}
