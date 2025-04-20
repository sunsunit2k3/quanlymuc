import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/providers/item_monitor_provider.dart';
import 'package:test_app/screens/item_monitoring_screen.dart';
import 'item_list_screen.dart';
import 'package:test_app/preferences_manager.dart'; // Import PreferencesManager

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final List<Item> _items = [];
  final List<Item> _monitoringItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    _loadItems();
    _loadMonitoringItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load items and monitoring items using PreferencesManager
  void _loadItems() async {
    final loadItems = await PreferencesManager.loadItems();
    setState(() {
      _items.clear();
      _items.addAll(loadItems);
      print('Loaded items: $_items');
    });
  }

  void _loadMonitoringItems() async {
    final monitoringItems = await PreferencesManager.loadMonitoringItems();
    setState(() {
      _monitoringItems.clear();
      _monitoringItems.addAll(monitoringItems);
      print('Loaded monitoring items: $_monitoringItems');
      print('Loaded monitoring items count: ${_monitoringItems.length}');
    });
  }

  // Toggle monitoring state and update preferences
  void toggleMonitoring(Item item) async {
    setState(() {
      final index = _items.indexWhere((d) => d == item);
      if (index != -1) {
        // Cập nhật trạng thái isMonitoring
        final updatedItem = _items[index].copyWith(
          isMonitoring: !_items[index].isMonitoring,
        );
        _items[index] = updatedItem;

        // Nếu đang theo dõi (isMonitoring = true), thêm vào _monitoringItems
        if (updatedItem.isMonitoring) {
          // Đảm bảo rằng item được thêm vào _monitoringItems và isMonitoring là true
          if (!_monitoringItems.contains(updatedItem)) {
            _monitoringItems.add(updatedItem);
          }
        } else {
          // Nếu không còn theo dõi (isMonitoring = false), xóa khỏi _monitoringItems
          _monitoringItems.removeWhere(
            (i) => i.name == updatedItem.name && i.value == updatedItem.value,
          );
        }
      }
    });

    // Lưu danh sách _items và _monitoringItems vào Preferences
    await PreferencesManager.saveItems(_items);
    await PreferencesManager.saveMonitoringItems(_monitoringItems);
  }

  Future<void> addItem(Item item) async {
    setState(() {
      _items.add(item);
    });
    await PreferencesManager.saveItems(_items);
  }

  Future<void> removeItem(Item item) async {
    setState(() {
      _items.remove(item);
    });
    await PreferencesManager.saveItems(_items);
  }

  @override
  Widget build(BuildContext context) {
    final monitoredCount = _monitoringItems.where((d) => d.isMonitoring).length;
    return ItemMonitorProvider(
      items: _items,
      monitoringItem:
          _monitoringItems.where((item) => item.isMonitoring).toList(),
      toggleMonitoring: toggleMonitoring,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ứng dụng của tôi')),
        body: TabBarView(
          controller: _tabController,
          children: const [ItemListScreen(), ItemMonitoringScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _tabController.animateTo(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.devices),
              label: 'Danh sách mục',
            ),
            BottomNavigationBarItem(
              icon:
                  monitoredCount > 0
                      ? Badge.count(
                        count: monitoredCount,
                        child: const Icon(Icons.bar_chart),
                      )
                      : const Icon(Icons.bar_chart),
              label: 'Theo dõi',
            ),
          ],
        ),
      ),
    );
  }
}
