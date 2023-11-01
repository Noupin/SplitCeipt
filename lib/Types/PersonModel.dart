import 'package:flutter/material.dart';

class PersonModel {
  final String id;
  String firstName;
  String lastName;
  String phone;
  Color color;

  PersonModel(this.firstName, this.lastName, this.phone, this.color)
      : id = UniqueKey().toString();

  // A method that changes the person's first name
  void changeFirstName(String newFirstName) {
    // Assign the new first name to the person's first name
    firstName = newFirstName;
  }

  // A method that changes the person's last name
  void changeLastName(String newLastName) {
    // Assign the new last name to the person's last name
    lastName = newLastName;
  }

  // A method that changes the person's phone number
  void changePhone(String newPhone) {
    // Assign the new phone number to the person's phone
    phone = newPhone;
  }

  // A method that returns the full name of the person
  String getFullName() {
    // Return a string with the person's first name and last name separated by a space
    return '$firstName $lastName';
  }

  String getInitials() {
    // Return the first letter of the first name and last name
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  // A method that returns a string representation of the person
  String toString() {
    // Return a string with the person's first name, last name and phone number
    return 'First Name: $firstName, Last Name: $lastName, Phone: $phone';
  }
}
