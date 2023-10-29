import 'package:flutter/material.dart';
import 'package:split_shit/Types/ItemModel.dart';

class CeiptModel {
  final String id;
  String name;
  final DateTime date;
  final List<ItemModel> items;

  CeiptModel(this.name, this.items)
      : id = UniqueKey().toString(),
        date = DateTime.now();
}
