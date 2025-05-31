import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButtom({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField(
        {Function(String)? onSubmit,
        Function(String)? onChange,
        required TextEditingController controler,
        required TextInputType type,
        String? Function(String?)? validator,
        required IconData prefix,
        required String lable,
        VoidCallback? click,
        bool isClickable = true}) =>
    TextFormField(
      controller: controler,
      keyboardType: type,
      onTap: click,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validator,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Time & Date section
          Column(
            children: [
              Text(
                '${model['time']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${model['data']}', // 👈 Display the date here
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(width: 16),

          // Title & Subtitle section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            '${model['title']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${model['subtitle']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Edit icon
          if (model.isNotEmpty)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.purpleAccent),
              onPressed: (){},
            ),
        ],
      ),
    ),
  );
}



  //

