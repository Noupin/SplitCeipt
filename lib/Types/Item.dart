import 'package:flutter/material.dart';
import 'package:split_shit/Types/Person.dart';

// A class that represents an item with a name, a cost, and a list of people
class Item {
  final String id;
  String name;
  double cost;
  final List<Person> people;

  Item(this.name, this.cost, this.people) : id = UniqueKey().toString();

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
  void addPerson(Person person) {
    // Add the person to the item's list of people
    people.add(person);
  }

  // A method that creates and adds a person to the item's list of people
  void addNewPerson(String name, String phoneNumber) {
    // Add the person to the item's list of people
    people.add(Person(name, phoneNumber));
  }

  // A method that removes a person from the item's list of people by their name
  void removePersonByName(Person person) {
    // Remove the person from the item's list of people by their name
    people.remove((person) => person.name == name);
  }

  // A method that removes a person from the item's list of people by their name
  void removePersonById(String id) {
    // Remove the person from the item's list of people by their name
    people.removeWhere((person) => person.id == id);
  }
}
