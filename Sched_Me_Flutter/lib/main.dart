import 'package:flutter/material.dart' hide View;
import 'package:provider/provider.dart';
import 'package:schedule_vikram/calendar.dart';
import 'package:schedule_vikram/classes.dart';
import 'package:schedule_vikram/sharing.dart';
import 'package:schedule_vikram/settings.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBar();
}

void main() {
  runApp(
    // MultiProvider(
    //   providers: [
        ChangeNotifierProvider(
          create: (context) => CalendarModel(),
          child: const NavBar(),
        ),
      // ],
      // child: const NavBar(),
    // )
  );
}

//NavBar which has navigation from page to page
class _NavBar extends State<NavBar> {
  // const NavBar({super.key});
  int _selectedIndex = 0;
  Color _selectedColor = Colors.blue;
  final List<Color> _colors = <Color>[
    //Colors
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.grey
  ];

  List<Widget> getAppBarWidgets(int index) {
    if (index == 0) {
      return <Widget>[
        const Plus(),
      ];
    }
    return <Widget>[];
  }

  //Nav Bar names
  static const List<Widget> _sections = <Widget>[
    Text('Calendar'),
    Text('Classes'),
    Text('Sharing'),
    Text('Settings'),
  ];

  //Different pages with their contents
  static const List<Widget> _widgetOptions = <Widget>[
    Calendar(),
    Class(),
    Sharing(),
    Settings(),
  ];

  //On tap, change index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedColor = _colors[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: _sections.elementAt(
              _selectedIndex), //Sets color of selected item and page to index of thing pressed
          actions: getAppBarWidgets(_selectedIndex),
          backgroundColor: _selectedColor,
        ),
        body: Center(
          child: Consumer<CalendarModel>(
            builder: (context, calendarModel, child) {
              return _widgetOptions.elementAt(_selectedIndex);
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _selectedColor,
          // selectedItemColor: Colors.amber[800],
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              label: 'Calendar',
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(
              label: 'Classes',
              icon: Icon(Icons.menu_book),
            ),
            BottomNavigationBarItem(
              label: 'Sharing',
              icon: Icon(Icons.people_alt),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
