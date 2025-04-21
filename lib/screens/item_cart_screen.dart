import 'package:flutter/material.dart';
import 'package:test_app/providers/item_monitor_provider.dart';

class ItemCartScreen extends StatefulWidget {
  const ItemCartScreen({super.key});

  @override
  State<ItemCartScreen> createState() => _ItemCartScreenState();
}

class _ItemCartScreenState extends State<ItemCartScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = ItemMonitorProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body:
          provider?.addToCartItem == null || provider!.addToCartItem.isEmpty
              ? const Center(child: Text('Mục giỏ hàng trống'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      key: const PageStorageKey('item_cart'),
                      itemCount: provider.addToCartItem.length,
                      itemBuilder: (context, index) {
                        final item = provider.addToCartItem[index];
                        return ListTile(
                          key: ValueKey(item.name + item.value),
                          title: Text("Item: ${item.name}"),
                          subtitle: Text("Price: ${item.price}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  item.isInCart
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  color: item.isInCart ? Colors.green : null,
                                ),
                                onPressed: () {
                                  provider.addingToCart(item);
                                  setState(() {
                                    item.isInCart =
                                        !item.isInCart; // Toggle cart state
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Tổng giá trị giỏ hàng: ${provider.addToCartItem.fold(0, (sum, item) => sum + item.price.toInt())} VNĐ',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
    );
  }
}
