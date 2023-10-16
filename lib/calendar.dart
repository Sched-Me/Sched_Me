import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Plus extends StatefulWidget {
  const Plus({super.key});
  @override
  State<Plus> createState() => _Plus();
}

//FIXME Display events on demand
class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _Calendar();
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

//Calendar class
class _Calendar extends State<Calendar> {

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    // final calendarModel = Provider.of<CalendarModel>(context);
    // CalendarDataSource data = calendarModel.ds;

    return Consumer<CalendarModel>(
        builder: (context, calendarModel, child) {
          return SfCalendar(
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.workWeek,
              CalendarView.month,
              CalendarView.timelineDay,
              CalendarView.timelineWeek,
              CalendarView.timelineWorkWeek,
              CalendarView.schedule,
              CalendarView.timelineMonth,
            ],
            controller: _controller,
            initialDisplayDate: DateTime.now(),
            onTap: calendarTapped,
            view: CalendarView.day,
            dataSource: calendarModel.ds,
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              agendaViewHeight: 400,
            ),
          );
          },
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    final calendarModel = Provider.of<CalendarModel>(context);

    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
        _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }

    //FIXME click on appointment and display details
    if (calendarTapDetails.targetElement == CalendarElement.appointment || calendarTapDetails.targetElement == CalendarElement.agenda) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(calendarModel.name),
            );
          }
      );
    }
  }
}

class CalendarModel extends ChangeNotifier {

  //Recurrence stuff
  RecurrenceType? type;
  int? interval;
  DateTime endRecurr = DateTime.now(); //End recurrence
  DateTime? startRecurr; //Start recurrence
  final List<WeekDays> _weekDays = []; //Weekdays appt recurs
  RecurrenceProperties? recurrence = RecurrenceProperties(startDate: DateTime.now());
  bool isRecurr = false;

  List<WeekDays> get weekDays => _weekDays;

  final List<Appointment> _appointments = <Appointment>[];
  final List<Widget> _classes = [];
  DataSource _ds = DataSource([]);
  bool _isAllDay = false;
  String? _notes = '';
  String? _location = '';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1);
  String name = 'New Event';

  DataSource get ds => _ds;

  set isAllDay(bool isAllDay) => _isAllDay = isAllDay;
  set notes(String? notes) => _notes = notes;
  set location(String? location) => _location = location;
  set startTime(DateTime startTime) => _startTime = startTime;
  set endTime(DateTime endTime) => _endTime = endTime;

  List<Widget> get classes => _classes;

  void _changeCalendarDataSource() {
    if(!isRecurr) {
        _appointments.add(
          Appointment(
            startTime: _startTime,
            endTime: _endTime,
            isAllDay: _isAllDay,
            subject: name,
            color: Colors.blue,
            notes: _notes,
            location: _location,
          ),
        );
      }
    else {
      recurrence = RecurrenceProperties(startDate: startRecurr ?? DateTime.now(), endDate: endRecurr, recurrenceType: type ?? RecurrenceType.weekly, interval: interval ?? 1, weekDays: _weekDays);
      _appointments.add(
        Appointment(
          startTime: _startTime,
          endTime: _endTime,
          isAllDay: _isAllDay,
          subject: name,
          color: Colors.blue,
          notes: _notes,
          location: _location,
          recurrenceRule: SfCalendar.generateRRule(recurrence ?? RecurrenceProperties(startDate: DateTime.now()), _startTime, _endTime)
        ),
      );
    }
    _ds = DataSource(_appointments);
  }

  bool isClassPr = false;

  //FIXME popup doesn't show up
  Widget addClass(BuildContext context){
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    const TextStyle optionStyle = TextStyle(fontSize: 30);
    const TextStyle info = TextStyle(fontSize: 20);

    // _classes.add(
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.red,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(style: optionStyle, name),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(style: info, 'Location: $_location'),
                      Text(style: info, 'All Day?: $_isAllDay'),
                      Text(style: info, 'Timing: ${DateFormat("h:mma").format(_startTime)} - ${DateFormat("h:mma").format(_endTime)}'),
                      // if(_recurrenceRule != null)
                      //   Text(style: info, 'Recurrence Rule: $_recurrenceRule'),
                      Text(style: info, 'Notes: $_notes'),
                    ],
                  ),
                );
              },
            );
          },
          child: SizedBox(
            width: width,
            height: 100,
            child: Center(
              child:Text(
                style: optionStyle,
                name,
              ),
            ),
          ),
        ),
      );
    // );
  }
}

//FIXME setup reccurence
class _Plus extends State<Plus> {

  bool isClass = false;

  bool reoccurring = false; //Used outside
  List<String> dates = ['Start Date', 'End Date'];
  List<String> times = ['Start Time', 'End Time'];

  bool isAllDay = false; //Used outside
  DateTime startDate = DateTime.now(); //Used outside
  DateTime endDate = DateTime.now(); //Used outside
  TimeOfDay startTime = TimeOfDay.now(); //Used outside
  TimeOfDay endTime = TimeOfDay.now(); //Used outside

  Future<DateTime> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 2, DateTime.now().month, DateTime.now().day),
    );

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }

    return startDate;
  }

  Future<DateTime> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 2, DateTime.now().month, DateTime.now().day),
    );

    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
    }

    return endDate;
  }

  Future<TimeOfDay> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        startTime = pickedTime;
      });
    }

    return startTime;
  }

  Future<TimeOfDay> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (pickedTime != null && pickedTime != endTime) {
      setState(() {
        endTime = pickedTime;
      });
    }

    return endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8.0, 0.0, 8.0),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.black),
        onPressed: () => showPlatformDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Consumer<CalendarModel>(
                  builder: (context, calendarModel, child) {
                    return BasicDialogAlert(
                      title: const Text('New Event'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onChanged: (String? value) {
                                setState(() {
                                  calendarModel.name = value ?? 'New Event';
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextFormField(
                              onChanged: (String? value) {
                                setState(() {
                                  calendarModel.location = value;
                                });
                              },
                              decoration: const InputDecoration(
                                // hintText: 'When does the class end?',
                                labelText: 'Location',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Text('Is the event all day?'),
                                Checkbox(
                                  value: isAllDay,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      calendarModel.isAllDay = value ?? false;
                                      isAllDay = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (!isAllDay)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          startDate = await _selectStartDate(context);
                                          calendarModel.startTime = startDate;
                                        },
                                        child: Text(dates[0]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            startTime = await _selectStartTime(context);
                                            calendarModel.startTime = DateTime(
                                                startDate.year, startDate.month,
                                                startDate.day, startTime.hour,
                                                startTime.minute);
                                          },
                                          child: Text(times[0]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          endDate = await _selectEndDate(context);
                                          calendarModel.endTime = endDate;
                                        },
                                        child: Text(dates[1]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            endTime = await _selectEndTime(context);
                                            calendarModel.endTime = DateTime(
                                                endDate.year, endDate.month,
                                                endDate.day, endTime.hour,
                                                endTime.minute);
                                          },
                                          child: Text(times[1]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (isAllDay)
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      startDate = await _selectStartDate(context,);
                                      calendarModel.startTime = startDate;
                                    },
                                    child: const Text('Start Date'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      endDate = await _selectEndDate(context);
                                      calendarModel.endTime = endDate;
                                    },
                                    child: const Text('End Date'),
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Text('Is the event reoccurring?'),
                                Checkbox(
                                  value: reoccurring,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      reoccurring = value ?? false;
                                      if (reoccurring) {
                                        showDropdownDialog();
                                        calendarModel.isRecurr = value ?? false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Text('Is the event a class?'),
                                Checkbox(
                                  value: isClass,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isClass = value ?? false;
                                      calendarModel.isClassPr = value ?? false;
                                      if(isClass){
                                        calendarModel.classes.add(calendarModel.addClass(context));
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            TextFormField(
                              onChanged: (String? value) {
                                setState(() {
                                  calendarModel.notes = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Notes',
                              ),
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.text,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: BasicDialogAction(
                                onPressed: () {
                                  calendarModel._changeCalendarDataSource();
                                  // calendarModel.ds.notifyListeners(CalendarDataSourceAction.add, calendarModel.ds.appointments ?? []);
                                  // Handle user submission here
                                  Navigator.of(context).pop();
                                },
                                title: const Text("Submit"), //FIXME: Does not work when using recurring
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        tooltip: 'Add Event',
      ),
    );
  }

  void fillDayFreq(List<String> dayFreq) {
    for (int i = 1; i <= 100; i++) {
      String s = i.toString();
      dayFreq.add(s);
    }
  }

  Future<DateTime> _selectEndRecurr(BuildContext context) async {
    final calendarModel = Provider.of<CalendarModel>(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 2, DateTime.now().month, DateTime.now().day),
    );

    if (pickedDate != null && pickedDate != calendarModel.endRecurr) {
      setState(() {
        calendarModel.endRecurr = pickedDate;
      });
    }

    return calendarModel.endRecurr;
  }

  void showDropdownDialog() {
    List<String> dayFreq = [];

    fillDayFreq(dayFreq);
    List<bool> isDay = List.generate(7, (index) => false);
    List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String recurrenceType = 'Daily';
        String recurrenceInterval = '1';

        return AlertDialog(
          title: const Text('Reoccurring'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Consumer<CalendarModel>(
              builder: (context, calendarModel, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: recurrenceType,
                      items: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          recurrenceType = value!;
                          switch(recurrenceType) {
                            case 'Daily':
                              calendarModel.type = RecurrenceType.daily;
                              break;
                            case 'Weekly':
                              calendarModel.type = RecurrenceType.weekly;
                              break;
                            case 'Monthly':
                              calendarModel.type = RecurrenceType.monthly;
                              break;
                            case 'Yearly':
                              calendarModel.type = RecurrenceType.yearly;
                              break;
                            default:
                          }
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        calendarModel.endRecurr = await _selectEndRecurr(context);
                        // _selectEndDate(context, DateTime.now()); //Placeholder
                      },
                      child: const Text('Recurrence End'),
                    ),
                    if (recurrenceType == 'Daily')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Every  '),
                          DropdownButton<String>(
                            value: recurrenceInterval,
                            items: dayFreq
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                recurrenceInterval = value!;
                                calendarModel.interval = int.parse(value);
                              });
                            },
                          ),
                          const Text('  Day(s)'),
                        ],
                      ),
                    if (recurrenceType == 'Weekly')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Every  '),
                          DropdownButton<String>(
                            value: recurrenceInterval,
                            items: dayFreq
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                recurrenceInterval = value!;
                                calendarModel.interval = int.parse(value);
                              });
                            },
                          ),
                          const Text('  Week(s)'),
                        ],
                      ),
                    if (recurrenceType == 'Weekly')
                      Column(
                        children: [
                          for (int i = 0; i < 7; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(daysOfWeek[i]),
                                Checkbox(
                                  value: isDay[i],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isDay[i] = value ?? false;
                                      switch(daysOfWeek[i]) {
                                        case 'Sunday':
                                          calendarModel.weekDays.add(WeekDays.sunday);
                                          break;
                                        case 'Monday':
                                          calendarModel.weekDays.add(WeekDays.monday);
                                          break;
                                        case 'Tuesday':
                                          calendarModel.weekDays.add(WeekDays.tuesday);
                                          break;
                                        case 'Wednesday':
                                          calendarModel.weekDays.add(WeekDays.wednesday);
                                          break;
                                        case 'Thursday':
                                          calendarModel.weekDays.add(WeekDays.thursday);
                                          break;
                                        case 'Friday':
                                          calendarModel.weekDays.add(WeekDays.friday);
                                          break;
                                        case 'Saturday':
                                          calendarModel.weekDays.add(WeekDays.saturday);
                                          break;
                                        default:
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    if (recurrenceType == 'Monthly')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Every  '),
                          DropdownButton<String>(
                            value: recurrenceInterval,
                            items: dayFreq
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                recurrenceInterval = value!;
                                calendarModel.interval = int.parse(value);
                              });
                            },
                          ),
                          const Text('  Month(s)'),
                        ],
                      ),
                    if(recurrenceType == 'Yearly')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Every  '),
                              DropdownButton<String>(
                                value: recurrenceInterval,
                                items: dayFreq
                                    .map<DropdownMenuItem<String>>((
                                    String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    recurrenceInterval = value!;
                                    calendarModel.interval = int.parse(value);
                                  });
                                },
                              ),
                              const Text('  Year(s)'),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              },
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
