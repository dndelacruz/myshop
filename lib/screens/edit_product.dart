import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).getItem(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() => _isLoading = true );
    
    if(_editedProduct.id != null) Provider.of<Products>(context, listen: false).updateItem(_editedProduct).then((_) {
      Navigator.of(context).pop();
    });
    else Provider.of<Products>(context, listen: false).addProduct(_editedProduct).catchError((error) {
      return showDialog<Null>(context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error occured'),
          content: Text('Something error happened.'),
          actions: <Widget>[
            FlatButton(child: Text('Ok'), onPressed: () => Navigator.of(context).pop() ,),
          ],
        ),
      );
    }).then((_) {
      Navigator.of(context).pop();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  initialValue: _editedProduct.title,
                  validator: (val) {
                    if (val.isEmpty) return 'Provide a valid value.';
                    return null;
                  },
                  onSaved: (val) {
                    _editedProduct = Product(
                        title: val,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite
                        );
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  initialValue: _editedProduct.price.toString(),
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  validator: (val) {
                    if (val.isEmpty) return 'Please enter a value.';
                    if (double.tryParse(val) == null ||
                        double.parse(val) <= 0.0)
                      return 'Please enter a valid value.';
                    return null;
                  },
                  onSaved: (val) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(val),
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  initialValue: _editedProduct.description,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (val) {
                    if (val.isEmpty) return 'Please enter a description.';
                    if (val.length < 10)
                      return 'Please enter a longer description.';
                    return null;
                  },
                  onSaved: (val) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        description: val,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text('No image loaded')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover),
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (val) {
                        if (val.isEmpty) return 'Please enter an image URL.';
                        if (!val.startsWith('http'))
                          return 'Please enter a valid image URL.';
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: val,
                            id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite);
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
