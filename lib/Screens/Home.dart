// Third Party Imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split_shit/Screens/Receipt.dart';

// First Party Imports
import '../State/State.dart';
import '../Types/CeiptModel.dart';
import '../Types/ItemModel.dart';
import '../Types/PersonModel.dart';

class HomeScreen extends StatelessWidget {
  // A reference to the app state
  AppState appState = AppState();
  bool postBuildRan = false;

  // A method that returns a list of receipts from the app state
  List<CeiptModel> getCeipts() {
    // Get the map of receipts from the app state
    Map<String, CeiptModel> ceiptMap = appState.ceiptMap;
    // Convert the map values to a list of receipts
    List<CeiptModel> ceipts = ceiptMap.values.toList();
    // Sort the list of receipts by date in descending order
    ceipts.sort((a, b) => b.date.compareTo(a.date));
    // Return the sorted list of receipts
    return ceipts;
  }

  // A method that returns a list of receipts from the past week
  List<CeiptModel> getRecentCeipts() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Get the date and time one week ago
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));
    // Get the list of all receipts
    List<CeiptModel> ceipts = getCeipts();
    // Filter the list of receipts by date and keep only those from the past week
    List<CeiptModel> recentCeipts =
        ceipts.where((ceipt) => ceipt.date.isAfter(oneWeekAgo)).toList();
    // Return the filtered list of receipts
    return recentCeipts;
  }

  // A method that returns a list of receipts from before the past week
  List<CeiptModel> getOlderCeipts() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Get the date and time one week ago
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));
    // Get the list of all receipts
    List<CeiptModel> ceipts = getCeipts();
    // Filter the list of receipts by date and keep only those from before the past week
    List<CeiptModel> olderCeipts =
        ceipts.where((ceipt) => ceipt.date.isBefore(oneWeekAgo)).toList();
    // Return the filtered list of receipts
    return olderCeipts;
  }

  // A method that returns a widget that displays a receipt item in a list tile
  Widget buildCeiptItem(CeiptModel ceipt, BuildContext context) {
    // Format the date of the receipt to a readable string
    String formattedDate = DateFormat.yMMMd().format(ceipt.date);
    // Format the total cost of the receipt to a currency string with two decimal places
    String formattedCost = '\$${ceipt.getTotalCost().toStringAsFixed(2)}';
    // Return a Dismissible widget that wraps the list tile widget
    return Dismissible(
      // Use the ceipt id as the key for the Dismissible widget
      key: Key(ceipt.id),
      // Set the direction to end to start, which means swiping from right to left
      direction: DismissDirection.endToStart,
      // Set the background to a red container with a delete icon
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      // Provide a function that removes the ceipt from the app state when dismissed
      onDismissed: (direction) {
        appState.removeCeipt(ceipt.id);
      },
      // Use the list tile widget as the child of the Dismissible widget
      child: ListTile(
        leading: Icon(Icons.receipt),
        title: Text(ceipt.name),
        subtitle: Text(formattedDate),
        trailing: Text(formattedCost),
        onTap: () {
          appState.setActiveCeiptId(ceipt.id);
          // Navigate to the receipt detail screen when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptScreen(),
            ),
          );
        },
      ),
    );
  }

  void initAppState() {
    PersonModel alice = PersonModel('Alice', "smith", '111-1111');
    PersonModel bob = PersonModel('Bob', "choo", '222-2222');
    PersonModel charlie = PersonModel('Charlie', "boi", '333-3333');

// Add the people to the app state
    appState.addPerson(alice);
    appState.addPerson(bob);
    appState.addPerson(charlie);

// Create some receipts with their names and items
    // Create some receipts with their names and items
    CeiptModel groceryStore = CeiptModel(
      'Grocery Store',
      [
        ItemModel('Milk', 2.99, [alice]),
        ItemModel('Eggs', 1.99, [bob]),
        ItemModel('Bread', 2.49, [charlie]),
        ItemModel('Cheese', 3.49, [alice, bob]),
        ItemModel('Apples', 1.38, [bob, charlie]),
      ],
    );

    CeiptModel restaurant = CeiptModel(
      'Restaurant',
      [
        ItemModel('Pizza', 12.99, [alice, bob, charlie]),
        ItemModel('Salad', 4.99, [alice]),
        ItemModel('Soda', 2.50, [bob]),
        ItemModel('Cake', 4.19, [charlie]),
        ItemModel('Tip', 5.00, [alice, bob, charlie]),
        ItemModel('Tax', 1.80, [alice, bob, charlie]),
      ],
    );

    CeiptModel movieTheater = CeiptModel(
      'Movie Theater',
      [
        ItemModel('Ticket', 10.00, [alice]),
        ItemModel('Popcorn', 3.00, [bob]),
        ItemModel('Candy', 1.00, [charlie]),
        ItemModel('Soda', 1.00, [alice, bob]),
      ],
    );

// Add the receipts to the app state
    appState.addCeipt(groceryStore);
    appState.addCeipt(restaurant);
    appState.addCeipt(movieTheater);
  }

  Future<void> postBuild() async {
    await Future.delayed(Duration.zero);
    // this code will get executed after the build method
    // because of the way async functions are scheduled
    if (!postBuildRan) {
      postBuildRan = true;
      initAppState();
      print("Build Completed");
    }
  }

  // This widget is the second screen of the application.
  @override
  Widget build(BuildContext context) {
    postBuild();
    appState = Provider.of<AppState>(context);
    // Get the list of recent receipts from the past week
    List<CeiptModel> recentCeipts = getRecentCeipts();
    // Get the list of older receipts from before the past week
    List<CeiptModel> olderCeipts = getOlderCeipts();

    // Return a scaffold widget with an app bar and a body
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              // Use the nextTheme method of appState, which is inherited from your AppState class
              appState.nextTheme(); // AppState: use your nextTheme method here
            },
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              // Use the toggleLeftHanded method of appState, which is inherited from your AppState class
              appState
                  .toggleLeftHanded(); // AppState: use your toggleLeftHanded method here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // If there are any recent receipts, display them in a section with a header
            if (recentCeipts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Past Week',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Use a container widget to create a background for the list
                  Container(
                    // Set the margin to create some space around the list
                    margin: EdgeInsets.all(8.0),
                    // Set the decoration to customize the color and shape of the background
                    decoration: BoxDecoration(
                      // Set the color to an accent color
                      color: Theme.of(context).colorScheme.secondary,
                      // Set the border radius to create rounded corners
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    // Use a list view builder to create a list of receipt items
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recentCeipts.length,
                      itemBuilder: (context, index) {
                        // Get the receipt at the index
                        CeiptModel ceipt = recentCeipts[index];
                        // Return a widget that displays the receipt item
                        return buildCeiptItem(ceipt, context);
                      },
                    ),
                  ),
                ],
              ),
            // If there are any older receipts, display them in a section with a header
            if (olderCeipts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Older',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Use a container widget to create a background for the list
                  Container(
                    // Set the margin to create some space around the list
                    margin: EdgeInsets.all(8.0),
                    // Set the decoration to customize the color and shape of the background
                    decoration: BoxDecoration(
                      // Set the color to an accent color
                      color: Theme.of(context).colorScheme.secondary,
                      // Set the border radius to create rounded corners
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    // Use a list view builder to create a list of receipt items
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: olderCeipts.length,
                      itemBuilder: (context, index) {
                        // Get the receipt at the index
                        CeiptModel ceipt = olderCeipts[index];
                        // Return a widget that displays the receipt item
                        return buildCeiptItem(ceipt, context);
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
