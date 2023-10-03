// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:attendance_monitoring/pages/home.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'server.dart';
import 'package:http/http.dart' as http;

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
  if (email.isEmpty || password.isEmpty) {
    String title = "Please Input Data";
    String message = "Username or Password Empty !";
    await showAlertDialog(context, title, message);
  } else {
    // HTTP request
    final response = await http.post(
      Uri.parse('${Server.host}auth/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    final message = data['message'];
    final status = "${response.statusCode}";
    if (response.statusCode == 200) {
      if (data['success']) {
        // set id for shared pref
        final userId = data['id'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);
        const title = "Login success";
        String content = "Welcome $message";
        await showAlertDialog(context, title, content);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      } else {
        const title = "Login failed";
        await showAlertDialog(context, title, message);
      }
    } else {
      const title = "Failed to log in";
      await showAlertDialog(context, title, status);
    }
  }
}