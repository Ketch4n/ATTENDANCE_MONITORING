import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/server.dart';
import '../model/stream_user_model.dart';
import '../model/user_model.dart';

Future<void> fetchUser(userStreamController) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final response = await http.post(
    Uri.parse('${Server.host}auth/user.php'),
    body: {'id': userId},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final user = UserModel.fromJson(data);

    // Add the user data to the stream
    userStreamController.add(user);
  } else {
    throw Exception('Failed to load data');
  }
}

Stream<List<StreamUserModel>> streamUser() async* {
  while (true) {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final response = await http.post(
      Uri.parse('${Server.host}auth/user.php'),
      body: {'id': userId},
    );
    // print('API Response: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      yield jsonList.map((json) => StreamUserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }

    await Future.delayed(
        const Duration(seconds: 2)); // Adjust the refresh rate as needed
  }
}
