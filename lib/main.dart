import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultPage = LogInPage();
  await Firebase.initializeApp();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
 SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  Future<int> _checkIfLoggedIn() async {
    final _prefs = await SharedPreferences.getInstance();
    int _isLoggedIn = _prefs.getInt('id');
    print('(Future) Is Logged In value from shared preferences is: ' + _isLoggedIn.toString());

    return _isLoggedIn;
  }

  int _isLoggedIn = await _checkIfLoggedIn();

  if (_isLoggedIn != null && _isLoggedIn > 0) {
    _defaultPage = DashPage();
  }

  return runApp(
    MaterialApp(
      home: _defaultPage,
      title: 'Planet Of Pets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    ),
  );
}
