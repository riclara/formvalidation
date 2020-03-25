import 'dart:convert';

import 'package:formvalidation/src/preferences/UserPreferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {

  final String _firebaseToken = 'AIzaSyD5rFR-bObPrpsVqv1ffhEeDagLk_X876k';
  final _prefs = UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: jsonEncode(authData)
    );

    Map<String, dynamic> decodeResp = jsonDecode(resp.body);
    print(decodeResp);
    if (decodeResp.containsKey('idToken')) {
      _prefs.token = decodeResp['idToken'];
      return {'ok': true, 'token': _prefs.token};
    }
    else return {'ok': false, 'token': decodeResp['error']['message']};
  } 

  Future<Map<String, dynamic>> newUser (String email, String password) async{
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: jsonEncode(authData)
    );

    Map<String, dynamic> decodeResp = jsonDecode(resp.body);
    print(decodeResp);
    if (decodeResp.containsKey('idToken')) return {'ok': true, 'token': decodeResp['idToken']};
    else return {'ok': true, 'token': decodeResp['error']['message']};
  }

}