// ignore_for_file: use_build_context_synchronously

import 'package:attendance_monitoring/auth/auth.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../style/style.dart';

logout(BuildContext context, purpose) {
  showDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          purpose == 'Logout' ? "Confirm Log out ?" : "Confirm Exit",
          style: Style.nexaBold,
        ),
        content: Text(
          purpose == 'Logout'
              ? 'You will be required to login again next time'
              : 'Are you sure you want to exit ?',
          style: Style.nexaRegular,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('userId');
              if (purpose == 'Exit') {
                Navigator.of(context).pop(true);
              }
              try {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Auth(),
                  ),
                );
              } catch (e) {
                // Handle exceptions here
                const title = "Error during logout";
                final message = "$e";
                await showAlertDialog(context, title, message);
              }
            },
          ),
        ],
      );
    },
  );
}
