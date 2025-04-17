import 'package:flutter/material.dart';
import 'package:test_app/providers/item_monitor_provider.dart';
import 'package:test_app/screens/add_item_screen.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Thêm item mới'),
                    content: AddItemScreen(
                      provider: provider,
                      onItemAdded: (newItem) {
                        provider?.addItem(newItem);
                        print({
                          'Item added: ${newItem.name}',
                          'Value: ${newItem.value}',
                          'Is Monitoring: ${newItem.isMonitoring}',
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: provider?.items.length ?? 0,
        itemBuilder: (context, index) {
          final item = provider!.items[index];
          return ListTile(
            title: Text(item.name),
            trailing: Icon(
              item.isMonitoring
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            onTap: () => provider.toggleMonitoring(item),
          );
        },
      ),
    );
  }
}
