import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/providers/item_monitor_provider.dart';

class AddItemScreen extends StatelessWidget {
  final ItemMonitorProvider? provider;
  final Function(Item) onItemAdded; // Callback to update state

  AddItemScreen({super.key, required this.provider, required this.onItemAdded});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Tên mục'),
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Giá trị'),
              controller: _valueController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final value = _valueController.text;

                if (name.isNotEmpty && value.isNotEmpty) {
                  final newItem = Item(
                    name: name,
                    value: value,
                    isMonitoring: false,
                  );
                  onItemAdded(
                    newItem,
                  ); // Update the parent widget with the new item
                  Navigator.of(
                    context,
                  ).pop(); // Đảm bảo đóng dialog sau khi thêm item
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập tên và giá trị cho mục'),
                    ),
                  );
                }
              },
              child: const Text('Thêm mục'),
            ),
          ],
        ),
      ),
    );
  }
}
