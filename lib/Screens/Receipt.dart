import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_shit/State/State.dart';
import 'package:split_shit/Types/ItemModel.dart';
import 'package:split_shit/Types/PersonModel.dart';
import 'package:split_shit/Widgets/CeiptListItem.dart';

import '../Helpers/Color.dart';

class ReceiptScreen extends StatefulWidget {
  // This widget is the first screen of the application.
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with SingleTickerProviderStateMixin {
  // A reference to the app state
  AppState appState = AppState();
  bool postBuildRan = false;

  // A list of sample initials
  final List<String> initials = [];
  final List<String> peopleAlreadyAdded = [];

  void getInitials() {
    for (ItemModel item in appState.getCeipt(appState.activeCeiptId).items) {
      for (PersonModel person in item.people) {
        if (peopleAlreadyAdded.contains(person.id)) {
          continue;
        }
        setState(() {
          initials.add(
              '${person.firstName[0].toUpperCase()}${person.lastName[0].toUpperCase()}');
        });
        peopleAlreadyAdded.add(person.id);
      }
    }
  }

  Future<void> postBuild() async {
    await Future.delayed(Duration.zero);
    // this code will get executed after the build method
    // because of the way async functions are scheduled
    if (!postBuildRan) {
      postBuildRan = true;
      getInitials();
      print("Build Completed");
    }
  }

  // This widget is the second screen of the application.
  @override
  Widget build(BuildContext context) {
    postBuild();
    appState = Provider.of<AppState>(context);
    print(appState.getCeipt(appState.activeCeiptId).items.length);
    return Scaffold(
        appBar: AppBar(
          title: Text('List and Grid Example'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // The top two-thirds of the screen is a ListView
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return buildCeiptItemWithPeople(
                        appState.getCeipt(appState.activeCeiptId));
                  },
                ),
              ),
              // The bottom third of the screen is a GridView
              Expanded(
                flex: 1,
                child: Padding(
                  // To add some top padding to the grid view
                  padding: EdgeInsets.only(top: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // The number of columns in the grid
                    ),
                    itemCount: initials.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(
                            15), // To add some spacing around the circles
                        decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // To make the container circular
                          color:
                              randomColor(), // The background color of the circle
                        ),
                        child: Text(
                          initials[index], // The text inside the circle
                          style: TextStyle(
                            color: Colors.white, // The color of the text
                            fontSize: 25, // The size of the text
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
