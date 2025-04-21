import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/providers/item_monitor_provider.dart';
import 'package:test_app/screens/item_cart_screen.dart';
import 'package:test_app/screens/item_monitoring_screen.dart';
import 'item_list_screen.dart';
import 'package:test_app/preferences_manager.dart';

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
  final List<Item> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    _loadItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load items and monitoring items using PreferencesManager
  void _loadItems() async {
    final loadItems = await PreferencesManager.loadItems();
    final monitoringItems = await PreferencesManager.loadMonitoringItems();
    final cartItems = await PreferencesManager.loadCartItems();

    setState(() {
      _items.clear();
      _items.addAll(loadItems);
      _monitoringItems.clear();
      _monitoringItems.addAll(monitoringItems);
      _cartItems.clear();
      _cartItems.addAll(cartItems);
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
          if (!_monitoringItems.contains(updatedItem)) {
            _monitoringItems.add(updatedItem);
          }
        } else {
          _monitoringItems.removeWhere(
            (i) => i.name == updatedItem.name && i.value == updatedItem.value,
          );
        }
      }
    });
    print('Monitoring items: $_monitoringItems');
    // Lưu danh sách _items và _monitoringItems vào Preferences
    await PreferencesManager.saveItems(_items);
    await PreferencesManager.saveMonitoringItems(_monitoringItems);
  }

  void addingToCart(Item item) async {
    setState(() {
      final index = _items.indexWhere((d) => d == item);
      if (index != -1) {
        // Cập nhật trạng thái isInCart
        final updatedItem = _items[index].copyWith(
          isInCart: !_items[index].isInCart,
        );
        _items[index] = updatedItem;
        if (updatedItem.isInCart) {
          if (!_cartItems.contains(updatedItem)) {
            _cartItems.add(updatedItem);
          }
        } else {
          _cartItems.removeWhere(
            (i) => i.name == updatedItem.name && i.value == updatedItem.value,
          );
        }
      }
    });
    print('Cart items: $_cartItems');
    await PreferencesManager.saveItems(_items);
    await PreferencesManager.saveCartItems(_cartItems);
  }

  @override
  Widget build(BuildContext context) {
    final monitoredCount = _monitoringItems.where((d) => d.isMonitoring).length;
    final cartCount = _cartItems.where((d) => d.isInCart).length;
    return ItemMonitorProvider(
      items: _items,
      monitoringItem:
          _monitoringItems.where((item) => item.isMonitoring).toList(),
      addToCartItem: _cartItems.where((item) => item.isInCart).toList(),
      toggleMonitoring: toggleMonitoring,
      addingToCart: addingToCart,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ứng dụng của tôi')),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: TabBarView(
            key: ValueKey<int>(
              _selectedIndex,
            ), // Ensures that AnimatedSwitcher triggers
            controller: _tabController,
            children: const [
              ItemListScreen(),
              ItemMonitoringScreen(),
              ItemCartScreen(),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: BottomNavigationBar(
            key: ValueKey<int>(
              _selectedIndex,
            ), // Ensure that AnimatedSwitcher triggers
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _tabController.animateTo(index);
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue, // Color when selected
            unselectedItemColor: Colors.grey, // Color when not selected
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
                          child: Icon(Icons.monitor_heart, color: Colors.green),
                        )
                        : Icon(Icons.monitor_heart),
                label: 'Theo dõi',
              ),
              BottomNavigationBarItem(
                icon:
                    cartCount > 0
                        ? Badge.count(
                          count: cartCount,
                          child: Icon(
                            Icons.shopping_cart_sharp,
                            color: Colors.green,
                          ),
                        )
                        : Icon(Icons.shopping_cart_sharp),
                label: 'Giỏ hàng',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
