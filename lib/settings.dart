import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {

  String newUsername = '';
  String newPassword = '';
  String confirmedPass = '';

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child:
      Column(
        children: [
          TextFormField(
            onSaved: (String? value) {
              newUsername = value ?? '';
            },
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Change Username',
            ),
          ),
          TextFormField(
            onSaved: (String? value) {
              newPassword = value ?? '';
            },
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Change Password',
            ),
          ),
          TextFormField(
            onSaved: (String? value) {
              confirmedPass = value ?? '';
            },
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Confirm Password',
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  color: Colors.grey,
                  child: const Text(
                    'Friend Requests',
                    style: TextStyle(fontSize: 25.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          ElevatedButton(
              onPressed: (){},
              child: const Text('Logout'),
          ),
          ElevatedButton(
            onPressed: (){},
            child: const Text('Delete Account'),
          ),
          const SizedBox(height: 300), // Add some extra space at the bottom if needed
        ],
      ),
    );
  }
}