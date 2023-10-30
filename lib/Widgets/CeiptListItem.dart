import 'package:flutter/material.dart';
import 'package:split_shit/Helpers/Color.dart';
import 'package:split_shit/Types/CeiptModel.dart';
import 'package:split_shit/Types/ItemModel.dart';
import 'package:split_shit/Types/PersonModel.dart';

// A method that returns a widget that displays a receipt item with people circles
Widget buildCeiptItemWithPeople(CeiptModel ceipt) {
  // Return a list tile widget with the receipt details
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (ItemModel item in ceipt.items) // Add a closing parenthesis here
        // Use a column widget to display the item name and the people circles
        ListTile(
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
                      // Add some margin around the circle
                      margin: EdgeInsets.all(4.0),
                      // Set the width and height to 24 pixels
                      width: 24.0,
                      height: 24.0,
                      // Set the decoration to customize the shape and color of the circle
                      decoration: BoxDecoration(
                        // Set the shape to circle
                        shape: BoxShape.circle,
                        // Set the color to an accent color
                        color: randomColor(),
                      ),
                      // Use a center widget to align the text widget inside the circle
                      child: Center(
                        // Use a text widget to display the person's initials
                        child: Text(
                          // Get the first and last characters of the person's name and capitalize them
                          '${person.firstName[0].toUpperCase()}${person.lastName[person.lastName.length - 1].toUpperCase()}',
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
          onTap: () => {
            print(
              'Item Name: ${item.name}, People: ${item.people}',
            )
          },
        )
    ],
  );
}
