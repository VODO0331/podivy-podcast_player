import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer _audioPlayer = AudioPlayer();

  void playAudio(String audioUrl) {
    _audioPlayer.play(UrlSource('https://content.blubrry.com/exponent/exponent_196.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace 'YOUR_AUDIO_URL' with the actual audio URL
            playAudio('https://content.blubrry.com/exponent/exponent_196.mp3');
          },
          child: Text('Play Audio'),
        ),
      ),
    );
  }
}
