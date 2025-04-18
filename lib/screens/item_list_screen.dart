import 'package:flutter/material.dart';
import 'package:test_app/providers/item_monitor_provider.dart';
import 'package:test_app/screens/add_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách mục')),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
    );
  }
}
