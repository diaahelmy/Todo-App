import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButtom({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback  function,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius)
      ),
      child: MaterialButton(
          onPressed: function,
          child: Text(text,style: const TextStyle(
            color: Colors.white
          ),),



      ),
    );


  Widget defaultFormField({
    Function(String)? onSubmit,
    Function(String)? onChange,
    required TextEditingController controler,
    required TextInputType type,
    String? Function(String?)? validator,
    required IconData prefix,
    required String lable,
    VoidCallback? click ,
    bool isClickable = true


  })=>TextFormField(
  controller: controler,
    keyboardType: type,
    onTap: click,
    enabled: isClickable,
    onFieldSubmitted:onSubmit ,
    onChanged: onChange,
    validator: validator,
    decoration: InputDecoration(
      labelText: lable,
      prefixIcon: Icon(prefix),
      border: OutlineInputBorder(),


    ),

);