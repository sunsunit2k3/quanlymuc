import 'package:flutter/material.dart';
import 'package:test_app/models/item_model.dart';
import 'package:test_app/providers/item_monitor_provider.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách mục')),
      body:
          provider?.items == null || provider!.items.isEmpty
              ? const Center(child: Text('Chưa có mục nào được thêm'))
              : ListView.builder(
                key: const PageStorageKey('item_list'),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return Dismissible(
                    key: ValueKey(item.name + item.value), // More unique key
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        provider.removeItem(item);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} đã bị xóa')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      key: ValueKey('item_${item.name}_${item.value}'),
                      title: Text(item.name),
                      subtitle: Text(item.value),
                      trailing: Icon(
                        item.isMonitoring
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      onTap: () {
                        provider.toggleMonitoring(item);
                        setState(() {
                          item.isMonitoring = !item.isMonitoring;
                        }); // Cập nhật lại UI khi trạng thái thay đổi
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, provider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, ItemMonitorProvider? provider) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Thêm mục mới'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tên mục',
                        border: OutlineInputBorder(),
                      ),
                      controller: nameController,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'Vui lòng nhập tên mục'
                                  : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Giá trị',
                        border: OutlineInputBorder(),
                      ),
                      controller: valueController,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'Vui lòng nhập giá trị'
                                  : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final newItem = Item(
                                name: nameController.text,
                                value: valueController.text,
                                isMonitoring: false,
                              );
                              setState(() {
                                provider?.addItem(newItem);
                              });

                              nameController.clear();
                              valueController.clear();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Cập nhật'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
