import 'package:flutter/material.dart';
import 'package:split_shit/Types/Item.dart';

class Ceipt {
  final String id;
  String name;
  final DateTime date;
  final List<Item> items;

  Ceipt(this.name, this.items)
      : id = UniqueKey().toString(),
        date = DateTime.now();
}
