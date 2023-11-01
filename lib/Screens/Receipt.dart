import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_shit/State/State.dart';
import 'package:split_shit/Types/ItemModel.dart';
import 'package:split_shit/Types/PersonModel.dart';
import 'package:split_shit/Helpers/Color.dart';
import 'package:split_shit/Types/CeiptModel.dart';

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
  String filterItemsByPerson = "";
  String filterPeopleByItem = "";
  bool renderFlag = true;

  // A list of sample initials
  final List<String> initialIds = [];
  final List<String> peopleAlreadyAdded = [];
  final List<String> filteredIds = [];

  void getInitials() {
    initialIds.clear();
    peopleAlreadyAdded.clear();
    var currentCeiptItems = appState.getCeipt(appState.activeCeiptId).items;
    for (ItemModel item in currentCeiptItems) {
      for (PersonModel person in item.people) {
        if (peopleAlreadyAdded.contains(person.id)) {
          continue;
        }
        setState(() {
          initialIds.add(person.id);
        });
        peopleAlreadyAdded.add(person.id);
      }
    }
    filterPeopleByItems();
  }

  void filterPeopleByItems() {
    List<String> filteringIds = List.from(initialIds);
    if (filterPeopleByItem.isNotEmpty) {
      List<PersonModel> peeps = appState
          .getCeipt(appState.activeCeiptId)
          .items
          .where((element) => element.id.contains(filterPeopleByItem))
          .first
          .people;
      filteringIds = filteringIds
          .where((element) => peeps.map((e) => e.id).contains(element))
          .toList();
    }

    setState(() {
      filteredIds.clear();
      filteringIds.forEach((element) {
        filteredIds.add(element);
      });
    });
  }

  // A method that returns a widget that displays a receipt item with people circles
  Widget buildCeiptItemWithPeople(CeiptModel ceipt) {
    List<ItemModel> filteredItems = List.from(ceipt.items);
    if (filterItemsByPerson.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) =>
              item.people.map((e) => e.id).contains(filterItemsByPerson))
          .toList();
    }

    // Return a list tile widget with the receipt details
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: Key(filteredIds.toString()),
      children: [
        for (ItemModel item in filteredItems) // Add a closing parenthesis here
          // Use a column widget to display the item name and the people circles
          Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) => {
              ceipt.removeItemById(item.id),
              appState.removeItem(ceipt.id, item.id),
              getInitials(),
            },
            child: ListTile(
              title: Row(
                children: [
                  // Use a text widget to display the item name
                  Text(item.name),
                  Expanded(child: Container()),
                  // Use a wrap widget to display the people circles
                  Wrap(
                    children: [
                      // Loop through each person in the item
                      for (PersonModel person in item.people)
                        // Use a container widget to create a circle with the person's initials
                        Container(
                          key: ValueKey(person.id),
                          // Add some margin around the circle
                          margin: EdgeInsets.all(4.0),
                          // Set the width and height to 24 pixels
                          width: 35.0,
                          height: 35.0,
                          // Set the decoration to customize the shape and color of the circle
                          decoration: BoxDecoration(
                            // Set the shape to circle
                            shape: BoxShape.circle,
                            // Set the color to an accent color
                            color: person.color,
                          ),
                          // Use a center widget to align the text widget inside the circle
                          child: Center(
                            // Use a text widget to display the person's initials
                            child: Text(
                              // Get the first and last characters of the person's name and capitalize them
                              '${person.firstName[0].toUpperCase()}${person.lastName[0].toUpperCase()}',
                              // Set the style to white and small font size
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                if (filterPeopleByItem.isEmpty) {
                  setState(() => filterPeopleByItem = item.id);
                } else {
                  setState(() => filterPeopleByItem = "");
                }
                filterPeopleByItems();
              },
            ),
          )
      ],
    );
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
                    itemCount: filteredIds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // To make the container circular
                              color: appState.personMap[initialIds[index]]!
                                  .color, // The background color of the circle
                            ),
                            child: Text(
                              appState.personMap[initialIds[index]]!
                                  .getInitials(), // The text inside the circle
                              style: TextStyle(
                                color: Colors.white, // The color of the text
                                fontSize: 25, // The size of the text
                              ),
                            ),
                          ),
                          onTap: () {
                            if (filterItemsByPerson.isEmpty) {
                              setState(() => filterItemsByPerson =
                                  appState.personMap[initialIds[index]]!.id);
                            } else {
                              setState(() => filterItemsByPerson = "");
                            }
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
