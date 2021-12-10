import 'package:flutter/material.dart';
import 'common_passwords.dart';

class PasswordStrengthMeter extends StatelessWidget {
  PasswordStrengthMeter({Key? key, required String password, CrackingMachine machine = CrackingMachine.desktop, CrackingCase crackingCase = CrackingCase.onAverage}) : super(key: key)
  {
    secondsToCrack = calculateTimeToCrack(password, machine.hashRate, crackingCase.factor);
    calculateSecurityScore(secondsToCrack);
  }

  final List<String> commonPasswords = CommonPasswords.get();
  late final BigInt secondsToCrack;
  late final double score;
  late final String message;
  late final Color color;

  BigInt calculateTimeToCrack(String password, int power, int crackingCaseFactor) {
    if (password.length < 4) {
      return BigInt.from(0);
    }

    if (commonPasswords.contains(password)) {
      return BigInt.from(0);
    }

    int numTypes = 0;

    // Contains lowercase?
    if (RegExp(r'[a-z]').hasMatch(password)) {
      numTypes += 26;
    }

    // Contains uppercase?
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      numTypes += 26;
    }

    // Contains numbers?
    if (RegExp(r'[0-9]').hasMatch(password)) {
      numTypes += 10;
    }

    // Contains symbols?
    if (RegExp(r'[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E]').hasMatch(password)) {
      numTypes += 32;
    }

    // Time to crack assuming randomness and 5b hashes/sec
    final BigInt combinations = BigInt.from(numTypes).pow(password.length);
    final BigInt seconds =
        combinations ~/ BigInt.from(power * crackingCaseFactor);

    return seconds;
  }

  void calculateSecurityScore(BigInt seconds){
    if(seconds >= BigInt.from(Duration.secondsPerDay * 365)) {
      score = 1.0;
      color = Colors.deepPurple;
      seconds > BigInt.from(Duration.secondsPerDay * 365 * 100)
        ? message = ">100 years"
        : message = "${seconds ~/ BigInt.from(Duration.secondsPerDay * 365)} years";
    }
    else if(seconds >= BigInt.from(Duration.secondsPerDay * 30)) {
      color = Colors.green;
      score = 0.75 + 0.25 * seconds.toDouble() / (60.0 * 60.0 * 24.0 * 365.0);
      message = "${seconds ~/ BigInt.from(Duration.secondsPerDay * 30)} months";
    }
    else if(seconds >= BigInt.from(Duration.secondsPerDay)) {
      score = 0.5 + 0.25 * seconds.toDouble() / (60.0 * 60.0 * 24.0 * 30.0);
      color = Color.lerp(Colors.yellow, Colors.green, score / 0.75 ) ?? Colors.black;
      message = "${seconds ~/ BigInt.from(Duration.secondsPerDay)} days";
    }
    else if(seconds >= BigInt.from(Duration.secondsPerHour)) {
      score = 0.25 + 0.25 * seconds.toDouble() / (60.0 * 60.0 * 24.0);
      color = Color.lerp(Colors.orange, Colors.yellow, score * 2) ?? Colors.black;
      message = "${seconds ~/ BigInt.from(Duration.secondsPerHour)} hours";
    }
    else if(seconds >= BigInt.from(Duration.secondsPerMinute)) {
      score = 0.125 + 0.125 * seconds.toDouble() / (60.0 * 60.0);
      color = Color.lerp(Colors.red, Colors.orange, score * 4) ?? Colors.black;
      message = "${seconds ~/ BigInt.from(Duration.secondsPerMinute)} minutes";
    }
    else {
      score = 0.125 * seconds.toDouble() / 60.0;
      color = Color.lerp(Colors.black, Colors.red, score * 8) ?? Colors.black;
      message = "$seconds seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 60,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              backgroundColor: Colors.black12,
              minHeight: 60,
              color: color,
              value: score,
            ),
          ),
          Center(
            child: Text(message,
                style: Theme.of(context).textTheme.headline5),
          ),
        ]
      ),
    );
  }
}

class CrackingMachine {
  final int hashRate;

  const CrackingMachine(this.hashRate);

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