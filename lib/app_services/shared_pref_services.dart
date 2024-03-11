import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPServices {
  Future<void> setLogInCredentials(AuthCredential credential) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint(credential.toString());
    await prefs.setString('credentials', credential.toString());
    await prefs.setString('token', 'loggedIn');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint(prefs.getString('token'));
    return prefs.getString('token');
  }

  Future<AuthCredential> getAuthCreds() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> data = json.decode(prefs.getString('credentials')!);
    late AuthCredential cred;
    if (data.isNotEmpty) {
      cred = AuthCredential(
          providerId: data['providerId'] ?? '',
          token: int.parse(data['token'] ?? '100'),
          signInMethod: data['signInMethod'] ?? '');
    }
    return cred;
  }

}
