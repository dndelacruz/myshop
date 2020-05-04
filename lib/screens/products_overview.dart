import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';

enum FilterOptions { Favorites, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}


class _ProductsOverviewState extends State<ProductsOverview> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshProducts() async {
    setState(() => _isLoading = true);
    await Provider.of<Products>(context, listen: false).getAndRefreshProducts();
    setState(() {
      _isLoading = false;
    });
    
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      setState(() => _isLoading = true);
      Provider.of<Products>(context, listen: false).getAndRefreshProducts().then((_) {
        setState(() => _isLoading = false );
      });
    }
    setState(() => _isInit = false);
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedFilter) {
                setState(() {
                  if (selectedFilter == FilterOptions.Favorites) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Favorites Only'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.numberOfItems.toString(),
              ),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.of(context).pushNamed('/cart-screen'),
                ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading ? Center(child: CircularProgressIndicator(),) 
        : ProductsGrid(_showFavoritesOnly));
  }
}
