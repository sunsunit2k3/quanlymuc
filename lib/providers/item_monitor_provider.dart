import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/preferences_manager.dart';

class ItemMonitorProvider extends InheritedWidget {
  final List<Item> items;
  final List<Item> monitoringItem;
  final List<Item> addToCartItem;
  final void Function(Item item) toggleMonitoring;
  final void Function(Item item) addingToCart;

  const ItemMonitorProvider({
    super.key,
    required super.child,
    required this.items,
    required this.monitoringItem,
    required this.addToCartItem,
    required this.toggleMonitoring,
    required this.addingToCart,
  });

  static ItemMonitorProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ItemMonitorProvider>();
  }

  @override
  bool updateShouldNotify(ItemMonitorProvider oldWidget) {
    return items != oldWidget.items ||
        monitoringItem != oldWidget.monitoringItem;
  }

  void addItem(Item item) {
    items.add(item);
    PreferencesManager.saveItems(items);
  }

  void removeItem(Item item) {
    items.remove(item);
    PreferencesManager.saveItems(items);
  }

  void remove(Item item) {
    items.remove(item);
    PreferencesManager.saveCartItems(items);
  }
}
