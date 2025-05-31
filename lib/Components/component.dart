import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/cubit/cubit.dart';

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

Widget buildTaskItem(Map model,context) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    child: Column(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Time Row
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    '${model['time']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    '${model['data']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Title
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 4),

              // Subtitle
              Text(
                '${model['subtitle']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        // Done/Archived buttons
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                  label: const Text('Done'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    AppCubit.get(context).updateDateBase(status: 'done', id: model['id']);


                  },
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[300],
              ),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(Icons.archive_outlined, size: 20, color: Colors.blueGrey),
                  label: Text('Archived'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    AppCubit.get(context).updateDateBase(status: 'archived', id: model['id']);


                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

