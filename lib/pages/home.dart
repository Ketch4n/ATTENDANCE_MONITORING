// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../api/user.dart';
import '../auth/logout.dart';
import '../include/navbar.dart';
import '../model/user_model.dart';
import '../widgets/snackbar.dart';
import 'dashboard.dart';
import 'dashboard/join.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State {
  final StreamController<UserModel> _userStreamController =
      StreamController<UserModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    await fetchUser(_userStreamController);
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  int _currentIndex = 0; // Initial index
  int _previousIndex = 0; // Store the previous index

  void _onMenuItemTap(int index) {
    setState(() {
      _previousIndex =
          _currentIndex; // Store the current index as the previous one
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // Handle back button press
    if (_currentIndex != _previousIndex) {
      // If the current index is not the same as the previous one,
      // return to the previous index.
      setState(() {
        _currentIndex = _previousIndex;
      });
      return false; // Prevent the app from exiting
    } else {
      // If the current index is the same as the previous one,
      // allow the app to exit.
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser(_userStreamController);
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isoffline = false;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    _userStreamController.close();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: StreamBuilder<UserModel>(
            stream: _userStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                final role = user.role;
                final section = user.section;
                final estab = user.establishment;
                if ((section == "0" || estab == "0") ||
                    estab == "0" && section == "0") {
                  return FloatingActionButton(
                    onPressed: () async {
                      if (_currentIndex == 0) {
                        bottomsheet(role, section, estab);
                      } else {
                        const purpose = "Logout";

                        await logout(context, purpose);
                      }
                    },
                    child: Icon(
                        _currentIndex == 0 ? Icons.add : Icons.exit_to_app),
                  );
                }
              }
              return const SizedBox();
            }),
        drawer: Navbar(onMenuItemTap: _onMenuItemTap),
        appBar: AppBar(
          title: Text(_currentIndex == 0 ? "Dashboard" : "Profile"),
          centerTitle: true,
        ),
        bottomNavigationBar: isoffline
            ? SizedBox(
                height: 50,
                child: BottomAppBar(
                  elevation: 0,
                  child: Center(
                    child: Container(
                      child: snack("You are currently Offline", isoffline),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            Dashboard(),
            Profile(),
          ],
        ),
        // use SizedBox to contrain the AppMenu to a fixed width
      ),
    );
  }

  Future bottomsheet(String role, String section, String estab) async {
    showAdaptiveActionSheet(
        context: context,
        title: Text(role == 'Student' ? 'Join' : 'Create'),
        androidBorderRadius: 20,
        actions: role == 'Student'
            ? <BottomSheetAction>[
                BottomSheetAction(
                    title: const Text(
                      'Section',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                      String purpose = "Section";
                      Navigator.of(context).pop(false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Join(
                              role: role,
                              purpose: purpose,
                              refreshCallback: _refreshData)));
                    }),
                BottomSheetAction(
                    title: const Text(
                      'Establishment',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                      String purpose = "Establishment";
                      Navigator.of(context).pop(false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Join(
                              role: role,
                              purpose: purpose,
                              refreshCallback: _refreshData)));
                    }),
              ]
            : role == 'Admin' || role == 'Establishment'
                ? <BottomSheetAction>[
                    BottomSheetAction(
                        title: Text(
                          role == 'Admin' ? 'Section' : 'Establishment',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "NexaBold"),
                        ),
                        onPressed: (context) {
                          String purpose =
                              role == 'Admin' ? 'Section' : 'Establishment';
                          Navigator.of(context).pop(false);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Join(
                                  role: role,
                                  purpose: purpose,
                                  refreshCallback: _refreshData)));
                        }),
                  ]
                : List.empty());
  }
}
