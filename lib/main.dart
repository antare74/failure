import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  // set default value for the state
  bool playing = false;
  IconData playBtn = Icons.play_arrow;

  // music obj
  AudioPlayer _player = AudioPlayer();
  AudioCache cache = AudioCache();

  Duration position = new Duration();
  Duration musicLength = new Duration();

  // custom slider

  Widget slider() {
    return Slider.adaptive(
      activeColor: Colors.blue[800],
      inactiveColor: Colors.grey[350],
      max: musicLength.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      onChanged: (value) {
        seekToSec(value.toInt());
      },
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }
  // init state

  @override
  void initState() {
    // Todo: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(
      fixedPlayer: _player,
    );

    // hadnel the audio time
    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // main UI
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 81, 97, 240),
              Color.fromARGB(224, 50, 116, 197),
              Color.fromARGB(225, 65, 149, 142),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 48.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // add title and description
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Music Beasts',
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // description
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Listen to your favorite songs',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: 48.0,
                ),
              ),

              Center(
                child: Container(
                  width: 280.0,
                  height: 280.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                      image: AssetImage("assets/penguin.png"),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(
                height: 18.0,
              ),

              Center(
                child: Text(
                  "Antare74",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600),
                ),
              ),

              SizedBox(
                height: 30.0,
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // add the time indicator text
                      Row(
                        children: [
                          Text(
                              "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              )),
                          slider(),
                          Text(
                              "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 45.0,
                            color: Colors.blue[400],
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_previous,
                            ),
                          ),
                          IconButton(
                            iconSize: 52.0,
                            color: Colors.blue[800],
                            onPressed: () {
                              if (!playing) {
                                cache.load("aimer.mp3");
                                setState(() {
                                  playing = true;
                                  playBtn = Icons.pause;
                                });
                              } else {
                                _player.pause();
                                setState(() {
                                  playing = false;
                                  playBtn = Icons.play_arrow;
                                });
                              }
                              log('play/pause button pressed: playing = $playing');
                            },
                            icon: Icon(
                              playBtn,
                            ),
                          ),
                          IconButton(
                            iconSize: 45.0,
                            color: Colors.blue[400],
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_next,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
