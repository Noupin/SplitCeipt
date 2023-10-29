import 'package:flutter/material.dart';
import 'package:split_shit/Types/PersonModel.dart';

// A class that represents an item with a name, a cost, and a list of people
class ItemModel {
  final String id;
  String name;
  double cost;
  final List<PersonModel> people;

  ItemModel(this.name, this.cost, this.people) : id = UniqueKey().toString();

  // A method that changes the item's name
  void changeName(String newName) {
    // Assign the new name to the item's name
    name = newName;
  }

  // A method that changes the item's cost
  void changeCost(double newCost) {
    // Assign the new cost to the item's cost
    cost = newCost;
  }

  // A method that adds a person to the item's list of people
  void addPerson(PersonModel person) {
    // Add the person to the item's list of people
    people.add(person);
  }

  // A method that creates and adds a person to the item's list of people
  void addNewPerson(String firstName, String lastName, String phoneNumber) {
    // Add the person to the item's list of people
    people.add(PersonModel(firstName, lastName, phoneNumber));
  }

  // A method that removes a person from the item's list of people by their name
  void removePersonByName(PersonModel person) {
    // Remove the person from the item's list of people by their name
    people.remove((person) => person.name == name);
  }

  // A method that removes a person from the item's list of people by their name
  void removePersonById(String id) {
    // Remove the person from the item's list of people by their name
    people.removeWhere((person) => person.id == id);
  }
}
