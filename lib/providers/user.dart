import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String _userId;
  String _userName;
  String _email;

  String get userName {
    return _userName;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }
}
