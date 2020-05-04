import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.deleteHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.of(context).pushNamed('/edit-product', arguments: id),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    deleteHandler(id, context);
                    
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
