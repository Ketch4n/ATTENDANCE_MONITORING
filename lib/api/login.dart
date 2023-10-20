import 'dart:convert';
import 'package:attendance_monitoring/pages/home.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'server.dart'; // Make sure you import your server configuration

<<<<<<< HEAD
Future<void> login(BuildContext context, String email, String password) async {
=======
import 'server.dart';

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
  if (email.isEmpty || password.isEmpty) {
    String title = "Please Input Data";
    String message = "Username or Password Empty !";
    // Add your showAlertDialog function here
    // Replace the next line with your showAlertDialog function
    await showAlertDialog(context, title, message);
  } else {
    try {
<<<<<<< HEAD
=======
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return Center(child: CircularProgressIndicator());
      //   },
      //   barrierDismissible: false,
      // );
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
      // HTTP request
      final response = await http.post(
        Uri.parse('${Server.host}auth/login.php'),
        body: {
          'email': email,
          'password': password,
        },
      );

<<<<<<< HEAD
      Map<String, dynamic> data = json.decode(response.body);
      final message = data['message'];
      final status = "${response.statusCode}";

      if (response.statusCode == 200) {
        if (data['success']) {
          // Set user ID in shared preferences
          final userId = data['id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);

          const title = "Login success";
          String content = "Welcome $message";
          // Add your showAlertDialog function here
          // Replace the next line with your showAlertDialog function
          await showAlertDialog(context, title, content);

          // Navigate to the home screen
=======
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        final message = data['message'];

        if (data['success']) {
          // set id for shared pref
          final userId = data['id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          const title = "Login success";
          String content = "Welcome $message";
          await showAlertDialog(context, title, content);
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        } else {
          const title = "Login failed";
<<<<<<< HEAD
          // Add your showAlertDialog function here
          // Replace the next line with your showAlertDialog function
=======
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
          await showAlertDialog(context, title, message);
        }
      } else {
        const title = "Failed to log in";
<<<<<<< HEAD
        // Add your showAlertDialog function here
        // Replace the next line with your showAlertDialog function
        await showAlertDialog(context, title, status);
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error as needed
=======
        await showAlertDialog(
            context, title, 'HTTP Status Code: ${response.statusCode}');
      }
    } catch (error) {
      const title = "Failed to log in";
      await showAlertDialog(context, title, 'Error: $error');
>>>>>>> 55f3baba961e9611ac31f7542a9ed52cc115a119
    }
    // finally {
    //   Navigator.pop(context); // Close loading indicator in all cases
    // }
  }
}


