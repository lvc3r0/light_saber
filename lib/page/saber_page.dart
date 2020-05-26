import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

import '../util/sound.dart';
import '../widget/plasma.dart';

class SaberPage extends StatefulWidget {
  SaberPage({Key key}) : super(key: key);

  @override
  _SaberPageState createState() => _SaberPageState();
}

class _SaberPageState extends State<SaberPage> {
  AudioCache audioCache = AudioCache(prefix: 'sounds/');
  final pageController = PageController(
    initialPage: 1,
  );

  bool mode = false;
  bool enableSound = false;
  bool saberOn = false;
  double widthSaber = 120;

  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  List<Color> colorPage = [];

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  bool played = false;

  @override
  void initState() {
    super.initState();
    int rColor = Random().nextInt(3);
    colorPage = [colorList[rColor], Color(0xff333333)];
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      //print('X : ${event.x}, Y : ${event.y}, Z : ${event.z}');
      if (saberOn && enableSound) {
        if (!mode) {
          if (event.y > 0.5) {
            play(Sound.lightSwingSequence);
          } else if (event.y < -0.5) {
            play(Sound.lightSwing1);
          }
        } else {
          if (event.y > 0.5) {
            play(Sound.lightSwingSequence);
          } else if (event.y < -0.5) {
            play(Sound.bulletDeflect);
          }
        }
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  play(String sound) async {
    if (!played) {
      played = true;
      AudioPlayer audioPlayer = await audioCache.play(sound);
      audioPlayer.onPlayerCompletion.listen((event) {
        played = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333333),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Plasma(
              pageController: pageController,
              colorPage: colorPage,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff808080),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    height: 40,
                    width: widthSaber,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 40,
                          child: GestureDetector(
                            child: Container(
                              height: 200,
                              width: widthSaber,
                              color: Colors.white,
                            ),
                            onTap: () {
                              onSaber();
                            },
                          ),
                        ),
                        Positioned(
                          right: 25,
                          top: 80,
                          child: GestureDetector(
                            child: Container(
                              height: 40,
                              width: 15,
                              decoration: BoxDecoration(
                                color: mode ? Colors.red : Color(0xff468847),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                mode = !mode;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff808080),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    height: 40,
                    width: widthSaber,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSaber() {
    int page = 0;
    setState(() {
      saberOn = !saberOn;
    });

    if (saberOn) {
      play(Sound.open);
    } else {
      page = 1;
      setState(() {
        enableSound = false;
      });
      play(Sound.close);
    }
    pageController
        .animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    )
        .then((value) {
      setState(() {
        enableSound = true;
      });
    });
  }
}
