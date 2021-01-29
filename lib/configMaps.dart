import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';

String mapkey = "AIzaSyCF_YpSfyAu2i62Tyb5iDw7SbeHxlETPuw";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPAgeStreamSubscription;



final player2 = AudioPlayer();

AudioCache player = AudioCache(prefix: 'assets/sounds/');

Position currentPosition;


