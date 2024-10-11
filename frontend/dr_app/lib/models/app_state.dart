// author: Renato García Morán
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _email = '';

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notifica cuando el valor cambia
  }
}
