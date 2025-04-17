import 'package:flutter/material.dart';
import 'package:test_app/providers/item_monitor_provider.dart';

class ItemMonitoringScreen extends StatefulWidget {
  const ItemMonitoringScreen({super.key});
  @override
  State<ItemMonitoringScreen> createState() => _ItemMonitoringScreenState();
}

class _ItemMonitoringScreenState extends State<ItemMonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ItemMonitorProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi')),
      body: ListView.builder(
        itemCount: provider?.monitoringItem.length ?? 0,
        itemBuilder: (context, index) {
          final item = provider!.monitoringItem[index];
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
