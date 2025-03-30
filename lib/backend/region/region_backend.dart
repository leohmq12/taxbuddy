import 'package:flutter/material.dart';

class RegionProvider with ChangeNotifier {
  String? _selectedRegion;

  String? get selectedRegion => _selectedRegion;

  void selectRegion(String region) {
    _selectedRegion = region;
    notifyListeners(); // Notify UI to rebuild if necessary
  }

  void clearRegion() {
    _selectedRegion = null;
    notifyListeners();
  }
}