import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditPoductScreen.routeName,
                    arguments: id,
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(
                      context,
                      listen: false,
                    ).deleteProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
