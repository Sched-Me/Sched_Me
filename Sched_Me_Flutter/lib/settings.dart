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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: TextFormField(
            onSaved: (String? value) {
              newUsername = value ?? '';
            },
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Change Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: TextFormField(
          onSaved: (String? value) {
            newPassword = value ?? '';
          },
          decoration: const InputDecoration(
            // hintText: 'When does the class end?',
            labelText: 'Change Password',
          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: TextFormField(
            onSaved: (String? value) {
              confirmedPass = value ?? '';
            },
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Confirm Password',
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        ElevatedButton(
            onPressed: () {},
            child: const Text('Logout'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Are you sure you want to delete your account?"),
                    content: Wrap(
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                ),
                                onPressed: () {},
                                child: const Text("Delete My Account")
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            );
          },
          child: const Text('Delete Account'),
        ),
        const SizedBox(height: 300), // Add some extra space at the bottom if needed
      ],
    );
  }
}