import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:password_strength_meter/password_strength_meter.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PasswordStrengthMeter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PasswordStrengthMeter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text('Enter a safe password', style: Theme.of(context).textTheme.headline4),
            const Spacer(),
            FutureBuilder(
              future: loadAsset('assets/list1.txt').then((value) {
                return const LineSplitter().convert(value);
              }),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("Error loading password list.");
                    }
                    return PasswordStrengthMeter(password: password, numPasswords: 5, passwordList: snapshot.data as List<String>);
                  }
                  else{
                    return const CircularProgressIndicator();
                  }
                }
            ),
            TextField(
              onChanged: (String newVal) {
                setState(() {
                  password = newVal;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
      ),
    );
  }
}
