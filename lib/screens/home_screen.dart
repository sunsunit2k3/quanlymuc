import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/providers/item_monitor_provider.dart';
import 'package:test_app/screens/item_monitoring_screen.dart';
import 'item_list_screen.dart';

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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleMonitoring(Item item) {
    setState(() {
      final index = _items.indexWhere((d) => d == item);
      if (index != -1) {
        _items[index] = _items[index].copyWith(
          isMonitoring: !_items[index].isMonitoring,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final monitoredCount = _items.where((d) => d.isMonitoring).length;
    return ItemMonitorProvider(
      items: _items,
      monitoringItem: _items.where((item) => item.isMonitoring).toList(),
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
