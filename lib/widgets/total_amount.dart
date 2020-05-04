import 'package:flutter/material.dart';

class TotalAmount extends StatefulWidget {
  final double total;
  final Function addHandler;

  TotalAmount(this.total, this.addHandler);

  @override
  _TotalAmountState createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  var _isAddingOrder = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total', style: TextStyle(fontSize: 20)),
            Spacer(),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                '\$${widget.total.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
            ),
            FlatButton(
              child: _isAddingOrder
                  ? CircularProgressIndicator()
                  : Text('ORDER NOW'),
              onPressed: widget.total == 0
                  ? null
                  : () async {
                      setState(() => _isAddingOrder = true);
                      await widget.addHandler();
                      setState(() => _isAddingOrder = false);
                    },
              disabledTextColor: Colors.grey,
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
