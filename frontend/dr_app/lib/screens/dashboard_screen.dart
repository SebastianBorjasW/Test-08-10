// author: Renato García Morán
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}