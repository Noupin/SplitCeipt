// Third Party Imports
import 'dart:collection';
import 'package:flutter/material.dart';

// First Party Imports
import 'Types/CeiptModel.dart';

class AppState extends ChangeNotifier {
  String theme = "system";
  bool leftHanded = false;
  Map<String, CeiptModel> ceiptMap = HashMap();

  // Add a method to add a Ceipt to the map
  void addCeipt(CeiptModel ceipt) {
    // Add the Ceipt to the map
    ceiptMap[ceipt.id] = ceipt;
    // Notify the listeners that the data has changed
    notifyListeners();
  }

  void removeCeipt(String ceiptId) {
    ceiptMap.removeWhere((key, value) => key == ceiptId);
    notifyListeners();
  }

  void updateCeipt(CeiptModel ceipt) {
    ceiptMap[ceipt.id] = ceipt;
    notifyListeners();
  }

  CeiptModel getCeipt(String ceiptId) {
    if (ceiptMap.containsKey(ceiptId)) {
      return ceiptMap[ceiptId]!;
    }
    throw Exception("Ceipt not found in map");
  }

  void setTheme(String newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  void setLeftHanded(bool newLeftHanded) {
    leftHanded = newLeftHanded;
    notifyListeners();
  }
}
