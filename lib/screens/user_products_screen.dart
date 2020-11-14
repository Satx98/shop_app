import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditPoductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Products>(
          context,
          listen: false,
        ).fetchAndSetProducts(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => ListView.builder(
              itemBuilder: (_, i) => UserProductItem(
                productsData.items[i].id,
                productsData.items[i].title,
                productsData.items[i].imageUrl,
              ),
              itemCount: productsData.items.length,
            ),
          ),
        ),
      ),
    );
  }
}
