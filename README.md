# test_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Bài tập thực hành Danh sách mục

### Bài 1: Thêm tính năng thêm/xóa mục

Trong bài tập này, chúng ta sẽ tạo một ứng dụng cho phép thêm và xóa các mục trong danh sách. Các tính năng bao gồm:

- Thêm mục mới vào danh sách.
- Xóa mục khi vuốt.

Dưới đây là mã nguồn cho phần này:

```dart
class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  } 
```

```dart
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Thêm mục mới'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Tên mục',
                          border: OutlineInputBorder(),
                        ),
                        controller: nameController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Giá trị',
                          border: OutlineInputBorder(),
                        ),
                        controller: valueController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            final name = nameController.text;
                            final value = valueController.text;
                            if (name.isNotEmpty && value.isNotEmpty) {
                              final newItem = Item(
                                name: name,
                                value: value,
                                isMonitoring: false,
                              );
                              setState(() {
                                provider?.addItem(newItem);
                              });
                              nameController.clear();
                              valueController.clear();

                              Navigator.of(
                                context,
                              ).pop(); // Đóng dialog sau khi thêm item
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Vui lòng nhập tên và giá trị cho mục',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Cập nhật'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
```
### Bài 2: Lưu vào Share Preferences
Truy cập file items_monitor_provider.dart
```dart
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map((item) => item.toJson()).toList();
    await prefs.setString(_itemsKey, jsonEncode(itemsJson));
  }

  static Future<List<Item>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString(_itemsKey);
    if (itemsJson != null) {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((item) => Item.fromJson(item)).toList();
    }
    return [];
  }
```
Trang homescreen.dart
```dart
  void _loadItems() async {
    final savedItems = await ItemMonitorProvider.loadItems();
    setState(() {
      _items.clear();
      _items.addAll(savedItems);
    });
  }
  ```
### Bài 3
