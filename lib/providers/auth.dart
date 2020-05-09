import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpiry;
  String _userId;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if(_tokenExpiry != null && _tokenExpiry.isAfter(DateTime.now()) && _token !=null){
      return _token;
    }
    return null;
  }

  String get userId {
    if(_tokenExpiry != null && _tokenExpiry.isAfter(DateTime.now()) && _token !=null){
      return _userId;
    }
    return null;
  }

  // check if there is still a valid token and auto login
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;
    final userData = json.decode(prefs.getString('userData'));
    if(DateTime.parse(userData['tokenExpiry']).isBefore(DateTime.now())) return false;
    _token = userData['token'];
    _tokenExpiry = DateTime.parse(userData['tokenExpiry']);
    _userId = userData['userId'];
    notifyListeners();
    _autoLogOut();
    return true;
  }

  // internal method for both signup and login with error handling
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDljalI6f1tLUFcm-k851JeoSazfh5VXJA';

    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    print(json.decode(response.body));
    final responseData = json.decode(response.body);
    if (responseData['error'] != null)
      throw HttpException(responseData['error']['message']);
    else {
      _token = responseData['idToken'];
      _tokenExpiry = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'] as String)));
      _userId = responseData['localId'];
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'tokenExpiry': _tokenExpiry.toIso8601String(),
        'userId': _userId
      });
      prefs.setString('userData', userData);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signout() async {
    _token = null;
    _userId = null;
    _tokenExpiry = null;
    if(_authTimer != null) _authTimer.cancel();
    _authTimer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut(){
    if(_authTimer != null) _authTimer.cancel();
    int _timeDifference = _tokenExpiry.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeDifference), signout);
  }
}
