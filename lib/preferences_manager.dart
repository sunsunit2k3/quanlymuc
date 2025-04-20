import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/models/item_model.dart';

class PreferencesManager {
  static const String _monitoringKey = 'monitoring_items';
  static const String _itemsKey = 'saved_items';

  // Load all items
  static Future<List<Item>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString(_itemsKey);
    if (itemsJson != null) {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  }

  // Save all items
  static Future<void> saveItems(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map((item) => item.toJson()).toList();
    await prefs.setString(_itemsKey, jsonEncode(itemsJson));
  }

  // Load all monitoring items
  static Future<List<Item>> loadMonitoringItems() async {
    final prefs = await SharedPreferences.getInstance();
    final monitoringItemsJson = prefs.getString(_monitoringKey);
    if (monitoringItemsJson != null) {
      final List<dynamic> decoded = jsonDecode(monitoringItemsJson);
      return decoded.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  }

  // Save all monitoring items
  static Future<void> saveMonitoringItems(List<Item> monitoringItems) async {
    final prefs = await SharedPreferences.getInstance();
    final monitoringItemsJson =
        monitoringItems.map((item) => item.toJson()).toList();
    await prefs.setString(_monitoringKey, jsonEncode(monitoringItemsJson));
  }
}
