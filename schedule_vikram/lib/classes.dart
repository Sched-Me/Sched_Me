import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_vikram/calendar.dart';

class Class extends StatefulWidget {
  const Class({super.key});
  @override
  State<Class> createState() => _Class();
}

class _Class extends State<Class> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarModel>(
        builder: (context, calendarModel, child) {
          return Column(
            children: [
              for(int i = 0; i < calendarModel.classes.length; i++)
                calendarModel.classes[i],
            ],
          );
        }
    );
  }
}