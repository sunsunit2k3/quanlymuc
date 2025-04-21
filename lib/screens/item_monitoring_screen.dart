import 'package:flutter/material.dart';
import 'package:test_app/providers/item_monitor_provider.dart';

class ItemMonitoringScreen extends StatefulWidget {
  const ItemMonitoringScreen({super.key});
  @override
  State<ItemMonitoringScreen> createState() => _ItemMonitoringScreenState();
}

class _ItemMonitoringScreenState extends State<ItemMonitoringScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi')),
      body:
          provider?.monitoringItem == null || provider!.monitoringItem.isEmpty
              ? const Center(child: Text('Chưa có mục nào được theo dõi'))
              : ListView.builder(
                key: const PageStorageKey(
                  'item_monitoring',
                ), // PageStorageKey để lưu trạng thái scroll
                itemCount: provider.monitoringItem.length,
                itemBuilder: (context, index) {
                  final item = provider.monitoringItem[index];
                  return ListTile(
                    key: ValueKey(
                      'monitoring_item_${item.name}_${item.value}_${DateTime.now().microsecondsSinceEpoch} ',
                    ),
                    title: Text(item.name),
                    trailing: Icon(
                      item.isMonitoring
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    onTap: () {
                      provider.toggleMonitoring(item);
                      setState(() {
                        print(DateTime.now().microsecond);
                        item.isMonitoring = !item.isMonitoring;
                      });
                    },
                  );
                },
              ),
    );
  }
}
