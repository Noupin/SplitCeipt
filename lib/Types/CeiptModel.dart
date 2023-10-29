// First Party Imports
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// Third Party Imports
import 'package:split_shit/Types/ItemModel.dart';
import 'package:split_shit/Types/PersonModel.dart';

class CeiptModel {
  final String id;
  String name;
  final DateTime date;
  final List<ItemModel> items;

  CeiptModel(this.name, this.items)
      : id = UniqueKey().toString(),
        date = DateTime.now();

  // A method that changes the receipt's name
  void changeName(String newName) {
    // Assign the new name to the receipt's name
    name = newName;
  }

  // A method that adds an item to the receipt's list of items
  void addItem(ItemModel item) {
    // Add the item to the receipt's list of items
    items.add(item);
  }

  // A method that creates and adds an item to the receipt's list of items
  void addNewItem(String name, double cost, List<PersonModel> people) {
    // Add the item to the receipt's list of items
    items.add(ItemModel(name, cost, people));
  }

  // A method that removes an item from the receipt's list of items by its name
  void removeItemByName(String name) {
    // Remove the item from the receipt's list of items by its name
    items.removeWhere((item) => item.name == name);
  }

  // A method that removes an item from the receipt's list of items by its id
  void removeItemById(String id) {
    // Remove the item from the receipt's list of items by its id
    items.removeWhere((item) => item.id == id);
  }

  void updateItem(ItemModel item) {
    // Find the index of the item in the receipt's list of items by its id
    int index = items.indexWhere((item) => item.id == item.id);
    // Check if the index is valid
    if (index != -1) {
      // Replace the item at the index with the new item
      items[index] = item;
    } else {
      // Throw an exception if the item is not found
      throw Exception("Item not found in receipt");
    }
  }

  // A method that returns an item from the receipt's list of items by its id
  ItemModel getItem(String itemId) {
    // Find the item in the receipt's list of items by its id
    ItemModel? item = items.firstWhereOrNull((item) => item.id == itemId);
    // Check if the item is not null
    if (item != null) {
      // Return the item
      return item;
    } else {
      // Throw an exception if the item is not found
      throw Exception("Item not found in receipt");
    }
  }

  // A method that calculates the total cost of the receipt
  double getTotalCost() {
    // Initialize a variable to store the total cost
    double totalCost = 0.0;
    // Loop through each item in the receipt's list of items
    for (ItemModel item in items) {
      // Add the item's cost to the total cost
      totalCost += item.cost;
    }
    // Return the total cost
    return totalCost;
  }
}
