import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/app_cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  required Color color,
  required String text,
  required void Function() function,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: function,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String labelText,
  required IconData prefixIcon,
  required FormFieldValidator<String> validate,
  IconData? suffixIcon,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool isPassword = false,
  double radius = 10.0,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      onChanged: onChanged,
      onTap: onTap,
      validator: validate,
      onFieldSubmitted: onSubmitted,
    );

Widget buildTaskItem(Map model,context) => Dismissible(
  key:Key(model['id'].toString()),
  child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']}',
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(status: 'done', id: model['id'],);
                },
                icon: const Icon(
                    Icons.check_box),
                    color: Colors.green,
            ),
            IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(status: 'archived', id: model['id'],);

                },
                icon: Icon(
                    Icons.archive),
                    color: Colors.black45,
            ),
          ],
        ),
      ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id'],);
  },
);

Widget taskBuilder({
  required List<Map> tasks ,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context,index) =>
          buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yey, Please Insert Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    ),
  ),
);
