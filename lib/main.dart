import 'package:flutter/material.dart';
import 'package:password_strength_meter/password_strength_meter.dart';

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
            PasswordStrengthMeter(password: password),
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
