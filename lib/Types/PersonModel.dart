import 'package:flutter/material.dart';

class PersonModel {
  final String id;
  String name;
  String phone;

  PersonModel(this.name, this.phone) : id = UniqueKey().toString();
}
