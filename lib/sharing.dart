import 'package:flutter/material.dart';

class Sharing extends StatefulWidget {
  const Sharing({super.key});
  @override
  State<Sharing> createState() => _Sharing();
}

class _Sharing extends State<Sharing> {
  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child:
        Column(
        children: [
          const Text(
            "Friends who don't have class",
            style: TextStyle(fontSize: 25.0),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  color: Colors.green,
                  child: const Text(
                    'Friend Example 1',
                    style: TextStyle(fontSize: 25.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          const Text(
            "Friends who have class",
            style: TextStyle(fontSize: 25.0),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  color: Colors.green,
                  child: const Text(
                    'Friend Example 2',
                    style: TextStyle(fontSize: 25.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          const Text(
            'Add Friends',
            style: TextStyle(fontSize: 25.0),
          ),
          TextFormField(
            onSaved: (String? value) {},
            decoration: const InputDecoration(
              // hintText: 'When does the class end?',
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 150), // Add some extra space at the bottom if needed
        ],
      ),
    );
  }
}