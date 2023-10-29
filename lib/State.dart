// Third Party Imports
import 'dart:collection';
import 'package:flutter/material.dart';

// First Party Imports
import 'Types/CeiptModel.dart';
import 'Types/ItemModel.dart';
import 'Types/PersonModel.dart';

class AppState extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;
  bool leftHanded = false;
  Map<String, CeiptModel> ceiptMap = HashMap();
  Map<String, PersonModel> personMap = HashMap();

  // Ceipt Methods
  void addCeipt(CeiptModel ceipt) {
    ceiptMap[ceipt.id] = ceipt;
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

  // Item Methods
  void addItem(String ceiptId, ItemModel item) {
    if (ceiptMap.containsKey(ceiptId)) {
      CeiptModel ceipt = getCeipt(ceiptId);
      ceipt.addItem(item);
      updateCeipt(ceipt);
    } else {
      throw Exception("Ceipt not found in map");
    }
  }

  void removeItem(String ceiptId, String itemId) {
    if (ceiptMap.containsKey(ceiptId)) {
      CeiptModel ceipt = getCeipt(ceiptId);
      ceipt.removeItemById(itemId);
      updateCeipt(ceipt);
    } else {
      throw Exception("Ceipt not found in map");
    }
  }

  void updateItem(String ceiptId, ItemModel item) {
    if (ceiptMap.containsKey(ceiptId)) {
      CeiptModel ceipt = getCeipt(ceiptId);
      ceipt.updateItem(item);
      updateCeipt(ceipt);
    } else {
      throw Exception("Ceipt not found in map");
    }
  }

  ItemModel getItem(String ceiptId, String itemId) {
    if (ceiptMap.containsKey(ceiptId)) {
      CeiptModel ceipt = getCeipt(ceiptId);
      return ceipt.getItem(itemId);
    } else {
      throw Exception("Ceipt not found in map");
    }
  }

  // Person Methods
  void addPerson(PersonModel person) {
    personMap[person.id] = person;
    notifyListeners();
  }

  void removePerson(String personId) {
    personMap.removeWhere((key, value) => key == personId);
    notifyListeners();
  }

  void updatePerson(PersonModel person) {
    personMap[person.id] = person;
    notifyListeners();
  }

  PersonModel getPerson(String personId) {
    if (personMap.containsKey(personId)) {
      return personMap[personId]!;
    }
    throw Exception("Person not found in map");
  }

  void setTheme(ThemeMode newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  // A function that takes the current theme and goes to the next one
  void nextTheme() {
    // Use a switch statement to check the current theme
    switch (theme) {
      case ThemeMode.dark:
        // If the current theme is dark, set it to light
        theme = ThemeMode.light;
        break;
      case ThemeMode.light:
        // If the current theme is light, set it to adaptive
        theme = ThemeMode.system;
        break;
      case ThemeMode.system:
        // If the current theme is adaptive, set it to dark
        theme = ThemeMode.dark;
        break;
    }
    // Notify the listeners of the state change
    notifyListeners();
  }

  void setLeftHanded(bool newLeftHanded) {
    leftHanded = newLeftHanded;
    notifyListeners();
  }

  void toggleLeftHanded() {
    leftHanded = !leftHanded;
    notifyListeners();
  }
}
