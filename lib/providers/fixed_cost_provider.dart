import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fixed_cost.dart';

class FixedCostProvider extends ChangeNotifier {
  late SharedPreferences _preferences;
  List<FixedCost> _fixedCosts = [];
  List<FixedCost> get fixCosts => _fixedCosts;

  FixedCostProvider() {
    _fixedCosts = [
      FixedCost(name: '住居費', amount: 15000),
      FixedCost(name: '通信費', amount: 6000),
      FixedCost(name: '光熱費', amount: 12000),
    ];
    _loadFromPreferences();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPreferences() async {
    await _initPreferences();
    final String? fixedCostsJson = _preferences.getString('fixedCosts');
    if (fixedCostsJson != null) {
      final List<dynamic> decoded = jsonDecode(fixedCostsJson);
      _fixedCosts = decoded.map((e) => FixedCost.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPreferences() async {
    await _initPreferences();
    final encoded = jsonEncode(_fixedCosts);
    await _preferences.setString('fixedCosts', encoded);
  }

  void addFixedCost(FixedCost fixedCost) {
    _fixedCosts.add(fixedCost);
    _saveToPreferences();
    notifyListeners();
  }

  void removeFixedCost(FixedCost fixedCost) {
    _fixedCosts.remove(fixedCost);
    _saveToPreferences();
    notifyListeners();
  }

  void updateFixedCost(FixedCost oldFixedCost, FixedCost newFixedCost) {
    final index = _fixedCosts.indexOf(oldFixedCost);
    if (index != -1) {
      _fixedCosts[index] = newFixedCost;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void reorderFixedCosts(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final FixedCost item = _fixedCosts.removeAt(oldIndex);
    _fixedCosts.insert(newIndex, item);
    notifyListeners();
  }

  int getTotalFixedCost() {
    int total = 0;
    for (var cost in _fixedCosts) {
      total += cost.amount;
    }
    return total;
  }
}
