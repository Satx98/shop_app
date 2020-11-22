import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> appDrawerItemBuilder({
    @required BuildContext context,
    @required String label,
    @required IconData icon,
    @required void Function() onTap,
  }) {
    return [
      Divider(),
      ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
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
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ...appDrawerItemBuilder(
              context: context,
              label: 'Orders',
              icon: Icons.payment,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  OrdersScreen.routeName,
                );
                // Navigator.of(context).pushReplacement(
                //   CustomRoute(
                //     builder: (_) => OrdersScreen(),
                //   ),
                // );
              }),
          ...appDrawerItemBuilder(
              context: context,
              label: 'Manage Products',
              icon: Icons.edit,
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          ...appDrawerItemBuilder(
              context: context,
              label: 'Logout',
              icon: Icons.exit_to_app,
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/');
              }),
        ],
      ),
    );
  }
}
