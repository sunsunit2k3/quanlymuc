import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';

class ItemMonitorProvider extends InheritedWidget {
  final List<Item> items;
  final List<Item> monitoringItem;
  final void Function(Item item) toggleMonitoring;
  const ItemMonitorProvider({
    super.key,
    required super.child,
    required this.items,
    required this.monitoringItem,
    required this.toggleMonitoring,
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
  }
}
