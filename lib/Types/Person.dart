import 'package:flutter/material.dart';

class Person {
  final String id;
  String name;
  String phone;

  Person(this.name, this.phone) : id = UniqueKey().toString();
}
