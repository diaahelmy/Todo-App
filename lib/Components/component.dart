import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
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

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
      direction: DismissDirection.endToStart, // Only allow swipe from right to left
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_forever, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Optional: Add confirmation dialog
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this task?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        AppCubit.get(context).deleteDataBase(id: model['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task deleted"),
            action: SnackBarAction(
              label: "Undo",
              textColor: Colors.white,
              onPressed: () {
               
              },
            ),
          ),
        );
      },
    child: Card(
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
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.deepPurple),
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
                    icon: Icon(Icons.check_circle_outline,
                        size: 20, color: Colors.green),
                    label: const Text('Done'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      AppCubit.get(context)
                          .updateDateBase(status: 'done', id: model['id']);
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
                    icon: Icon(Icons.archive_outlined,
                        size: 20, color: Colors.blueGrey),
                    label: Text('Archived'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      AppCubit.get(context)
                          .updateDateBase(status: 'archived', id: model['id']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget listTaskBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first task',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
