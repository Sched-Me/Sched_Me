import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_vikram/calendar.dart';

class Sharing extends StatefulWidget {
  const Sharing({super.key});
  @override
  State<Sharing> createState() => _Sharing();
}

class _Sharing extends State<Sharing> {
  List<String?> usernames = [];
  String username = '';
  // bool isVisible = false;

  @override
  Widget build(BuildContext context){
    return Consumer<CalendarModel>(
        builder: (context, calendarModel, child) {
          return SingleChildScrollView(
            child:
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                const Text(
                  "Friends who have class",
                  style: TextStyle(fontSize: 25.0),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: 350,
                    height: 200, // Fixed height of the container
                    child: ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Friend Example 1',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                const Text(
                  "Friend Requests",
                  style: TextStyle(fontSize: 25.0),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 5)),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: 350,
                    height: 200, // Fixed height of the container
                    child: ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Friend Requests',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                const Text(
                  'Add Friends',
                  style: TextStyle(fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    onFieldSubmitted: (String? value) {
                      setState(() {
                        if (!calendarModel.usernames.contains(value) && (value ?? '').trim().isNotEmpty) {
                          calendarModel.usernames.add(value);
                          calendarModel.isVisible = true;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      // hintText: 'When does the class end?',
                      labelText: 'Username',
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                for(int i = 0; i < calendarModel.usernames.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child:
                    Row(
                      children: [
                        Text(
                            style: const TextStyle(fontSize: 25.0),
                            '${calendarModel.usernames[i]}'
                        ),
                        const Spacer(),
                        Visibility(
                          visible: calendarModel.isVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  calendarModel.usernames.removeAt(i);
                                });
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 150),
              ],
            ),
          );
        }
    );
  }
}