import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> appDrawerItemBuilder({
    @required BuildContext context,
    @required String label,
    @required IconData icon,
    @required String routeName,
  }) {
    return [
      Divider(),
      ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(routeName);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ...appDrawerItemBuilder(
            context: context,
            label: 'Shop',
            icon: Icons.shop,
            routeName: '/',
          ),
          ...appDrawerItemBuilder(
            context: context,
            label: 'Orders',
            icon: Icons.payment,
            routeName: OrdersScreen.routeName,
          ),
          ...appDrawerItemBuilder(
            context: context,
            label: 'Manage Products',
            icon: Icons.edit,
            routeName: UserProductsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
