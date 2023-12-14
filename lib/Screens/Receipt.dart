import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_ceipt/Helpers/Color.dart';
import 'package:split_ceipt/State/State.dart';
import 'package:split_ceipt/Theme.dart';
import 'package:split_ceipt/Types/ItemModel.dart';
import 'package:split_ceipt/Types/PersonModel.dart';
import 'package:split_ceipt/Types/CeiptModel.dart';

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

    if (filterPeopleByItem.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) => item.id.contains(filterPeopleByItem))
          .toList();
    }

    // Return a list tile widget with the receipt details
    return Column(
      key: Key(filteredIds.toString()),
      children: [
        for (ItemModel item in (filterPeopleByItem.isNotEmpty
            ? filteredItems
            : ceipt.items)) // Add a closing parenthesis here
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
            child: Container(
                padding: const EdgeInsets.all(2.0),
                margin: const EdgeInsets.fromLTRB(
                    10, 2, 10, 2), // Set the padding amount
                decoration: BoxDecoration(
                  color: filteredItems
                          .map((element) => element.id)
                          .contains(item.id)
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.35),
                  borderRadius:
                      BorderRadius.circular(12.0), // Set the corner radius
                ),
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
                                color: filteredItems
                                        .map((element) => element.id)
                                        .contains(item.id)
                                    ? person.color
                                    : desaturate(person.color, 0.4, 0.5),
                              ),
                              // Use a center widget to align the text widget inside the circle
                              child: Center(
                                // Use a text widget to display the person's initials
                                child: Text(
                                  // Get the first and last characters of the person's name and capitalize them
                                  person.getInitials(),
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
                    if (filterPeopleByItem.isEmpty ||
                        !item.id.contains(filterPeopleByItem)) {
                      if (filterItemsByPerson.isNotEmpty) {
                        print(filterItemsByPerson);
                        if (!filteredItems
                            .map((element) => element.id)
                            .contains(item.id)) {
                          setState(() {
                            appState
                                .getCeipt(appState.activeCeiptId)
                                .items
                                .where((element) => element.id == item.id)
                                .first
                                .addPerson(
                                    appState.getPerson(filterItemsByPerson));
                          });
                        } else {
                          setState(() {
                            appState
                                .getCeipt(appState.activeCeiptId)
                                .items
                                .where((element) => element.id == item.id)
                                .first
                                .removePersonById(
                                    appState.getPerson(filterItemsByPerson).id);
                          });
                        }
                        return;
                      }
                      setState(() => filterPeopleByItem = item.id);
                    } else {
                      setState(() => filterPeopleByItem = "");
                    }
                    filterPeopleByItems();
                  },
                )),
          )
      ],
    );
  }

  // A function that returns a card widget for a person
  Widget buildPersonSection() {
    if (filterItemsByPerson.isNotEmpty) {
      PersonModel person = appState.getPerson(filterItemsByPerson);
      // Return a card widget with some properties
      return // Use a column widget to arrange the widgets vertically
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0), // Set the padding amount
                  child: Column(
                    // Use mainAxisAlignment to align the widgets to the center
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Use crossAxisAlignment to stretch the widgets to fill the horizontal space
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // Use children to add the widgets as a list
                    children: [
                      // Add the InkWell widget as the first child
                      Expanded(
                          child: InkWell(
                        child: Card(
                          // Set the color of the card to white
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // Use border side to set the border color and width
                            side: BorderSide(
                              color: Colors.black26,
                              width: 2.0,
                            ),
                          ),
                          // Set the margin of the card to 10 pixels on all sides
                          margin: EdgeInsets.all(10.0),
                          // Set the child of the card to a center widget
                          child: Center(
                            // Set the child of the center widget to a column widget
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  // Use mainAxisAlignment to align the widgets to the center
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // Use crossAxisAlignment to center the widgets horizontally
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Use children to add the widgets as a list
                                  children: [
                                    // Add a circle avatar widget as the first child of the column
                                    CircleAvatar(
                                      // Set the background color of the circle avatar to the person's color
                                      backgroundColor: person.color,
                                      minRadius: 45.0,
                                      // Set the child of the circle avatar to a text widget
                                      child: Text(
                                        // Set the text of the text widget to the person's initials
                                        person.getInitials(),
                                        // Set the style of the text widget to white and large font size
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40.0,
                                        ),
                                      ),
                                    ),
                                    // Add a text widget as the second child of the column
                                    Text(
                                      // Set the text of the text widget to the person's full name
                                      person.getFullName(),
                                      // Set the style of the text widget to black and bold font weight
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Add a text widget as the third child of the column
                                    Text(
                                      // Set the text of the text widget to the person's phone number
                                      person.phone,
                                      // Set the style of the text widget to gray and small font size
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        onTap: () => {setState(() => filterItemsByPerson = "")},
                      ))
                    ],
                  )));
    } else {
      return Expanded(
        flex: 1,
        child: Padding(
          // To add some top padding to the grid view
          padding: EdgeInsets.only(top: 20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // The number of columns in the grid
            ),
            itemCount: initialIds.length,
            itemBuilder: (context, index) {
              Color color = appState.personMap[initialIds[index]]!.color;
              if (!filteredIds.contains(initialIds[index])) {
                color = desaturate(color, 0.4, 0.5);
              }
              return ListTile(
                  title: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // To make the container circular
                      color: color, // The background color of the circle
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
                    if (filterItemsByPerson.isEmpty ||
                        !appState.personMap[initialIds[index]]!.id
                            .contains(filterItemsByPerson)) {
                      if (filterPeopleByItem.isNotEmpty) {
                        if (!filteredIds.contains(initialIds[index])) {
                          setState(() {
                            appState
                                .getCeipt(appState.activeCeiptId)
                                .items
                                .where((element) =>
                                    element.id.contains(filterPeopleByItem))
                                .first
                                .addPerson(
                                    appState.personMap[initialIds[index]]!);
                          });
                        } else {
                          appState
                              .getCeipt(appState.activeCeiptId)
                              .items
                              .where((element) =>
                                  element.id.contains(filterPeopleByItem))
                              .first
                              .removePersonById(initialIds[index]);
                        }
                        filterPeopleByItems();
                        return;
                      }
                      setState(() => filterItemsByPerson =
                          appState.personMap[initialIds[index]]!.id);
                    } else {
                      setState(() => filterItemsByPerson = "");
                    }
                  });
            },
          ),
        ),
      );
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
    return Scaffold(
        appBar: AppBar(
          title: Text('List and Grid Example'),
        ),
        backgroundColor: customThemeData.colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // The top two-thirds of the screen is a ListView
              Expanded(
                flex: 2,
                child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Set the padding amount
                    child: Container(
                        decoration: BoxDecoration(
                          color: customThemeData.colorScheme
                              .secondary, // Set the background color
                          borderRadius: BorderRadius.circular(
                              12.0), // Set the corner radius
                        ),
                        child: ListView.builder(
                          itemCount: 1,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return buildCeiptItemWithPeople(
                                appState.getCeipt(appState.activeCeiptId));
                          },
                        ))),
              ),
              // The bottom third of the screen is a GridView
              buildPersonSection(),
            ],
          ),
        ));
  }
}
