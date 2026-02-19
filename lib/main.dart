import 'package:flutter/material.dart';
import'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "";
  int happinessLevel = 50;
  int hungerLevel = 50;
  final TextEditingController _controller = TextEditingController();
  Timer? _hungerTimer;

  @override 
  void initState(){
    super.initState();
    _startHungerTimer();

  }
  
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(
      Duration(seconds: 30),
      (timer) {
        setState(() {
          hungerLevel +=5;
          _updateHunger();
          });}
      );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _hungerTimer?.cancel();
    super.dispose();
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Widget _moodIndicator() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (happinessLevel > 70) ...[
            Text('Happy'),
            Icon(Icons.sentiment_satisfied, size: 30),
          ] else if (happinessLevel >= 30) ...[
            Text('Neutral'),
            Icon(Icons.sentiment_neutral, size: 30),
          ] else ...[
            Text('Sad'),
            Icon(Icons.sentiment_dissatisfied, size: 30),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name your pet',
              ),
              onSubmitted: (value) {
                  setState(() {
                    petName = value;
                  });
                  
                  _controller.clear();
              },
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _moodColor(happinessLevel),
                      BlendMode.modulate,
                    ),
                  child: Image.asset('assets/pet_image.png', scale: 5),
                  ),
                _moodIndicator(),
                ],
              ),
            ),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0)
            ),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
