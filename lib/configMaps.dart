import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapkey = "AIzaSyCF_YpSfyAu2i62Tyb5iDw7SbeHxlETPuw";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPAgeStreamSubscription;