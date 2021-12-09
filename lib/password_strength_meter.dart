import 'package:flutter/material.dart';
import 'common_passwords.dart';

class PasswordStrengthMeter extends StatelessWidget {
  PasswordStrengthMeter({Key? key, required this.password, this.machine = CrackingMachine.desktop, this.crackingCase = CrackingCase.onAverage}) : super(key: key);

  final String password;
  final CrackingMachine machine;
  final CrackingCase crackingCase;
  final List<String> commonPasswords = CommonPasswords.get();

  String checkPassword(){
    if(password.isEmpty) {
      return "Enter password";
    }

    if(password.length < 6) {
      return "0 seconds";
    }

    if (commonPasswords.contains(password)) {
      return "0 seconds";
    }

    // Check if password is in dictionary TODO

    int numTypes = 0;
    // Contains lowercase?
    if(RegExp(r'[a-z]').hasMatch(password)){
      numTypes += 26;
    }

    // Contains uppercase?
    if(RegExp(r'[A-Z]').hasMatch(password)){
      numTypes += 26;
    }

    // Contains numbers?
    if(RegExp(r'[0-9]').hasMatch(password)){
      numTypes += 10;
    }

    // Contains symbols?
    if(RegExp(r'[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E]').hasMatch(password)){
      numTypes += 32;
    }

    // Time to crack assuming randomness and 5b hashes/sec
    final BigInt combinations = BigInt.from(numTypes).pow(password.length);
    final BigInt seconds = combinations ~/ BigInt.from(machine.power * crackingCase.factor);

    if(seconds >= BigInt.from(Duration.secondsPerDay * 365)){
      return "${seconds ~/ BigInt.from(Duration.secondsPerDay * 365)} years";
    }
    if(seconds >= BigInt.from(Duration.secondsPerDay)){
      return "${seconds ~/ BigInt.from(Duration.secondsPerDay)} days";
    }
    if(seconds >= BigInt.from(Duration.secondsPerHour)){
      return "${seconds ~/ BigInt.from(Duration.secondsPerHour)} hours";
    }
    if(seconds >= BigInt.from(Duration.secondsPerMinute)){
      return "${seconds ~/ BigInt.from(Duration.secondsPerMinute)} minutes";
    }
    return "${seconds.toString()} seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(checkPassword(),
            style: Theme.of(context).textTheme.headline5));
  }
}

class CrackingMachine {
  final int power;

  const CrackingMachine(this.power);

  static const laptop = CrackingMachine(2000000000);
  static const desktop = CrackingMachine(5000000000);
  static const rig = CrackingMachine(40000000000);
  static const datacenter = CrackingMachine(800000000000);
}

class CrackingCase {
  final int factor;

  const CrackingCase(this.factor);

  static const onLongest = CrackingCase(1);
  static const onAverage = CrackingCase(2);
}