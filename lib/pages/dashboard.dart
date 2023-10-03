import 'dart:async';
import 'package:flutter/material.dart';
import '../api/user.dart';
import '../model/user_model.dart';
import '../style/style.dart';
import 'dashboard/card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final StreamController<UserModel> _userStreamController =
      StreamController<UserModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    await fetchUser(_userStreamController);
  }

  @override
  void initState() {
    super.initState();
    fetchUser(_userStreamController);
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamController.close();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      child: StreamBuilder<UserModel>(
        stream: _userStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.section_name == "No section" &&
                user.establishment_name == "No establishment") {
              return ListView(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60, bottom: 30),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              "assets/duck.gif",
                            ),
                          ),
                        ),
                        Text(
                            user.role == 'Student'
                                ? "No Section or Establishment !"
                                : user.role == 'Admin'
                                    ? 'No section found !'
                                    : 'No Establishment registered !',
                            style: Style.duck),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Switch Account"),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: user.section_name != "No section" &&
                        user.establishment_name != "No establishment"
                    ? 2
                    : 1,
                itemBuilder: (context, index) {
                  final section = user.section;
                  final establishment = user.establishment;
                  return ContainerCard(
                    index: index,
                    section: section,
                    establishment: establishment,
                    refreshCallback: _refreshData,
                  ); // Use the custom item here
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
