import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class EditPoductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditPoductScreenState createState() => _EditPoductScreenState();
}

class _EditPoductScreenState extends State<EditPoductScreen> {
  final _form = GlobalKey<FormState>();

  var _imageUrl = '';
  var _hasErrorLoadingImage = false;
  var _loadingImage = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  Future<void> _updateImageUrl(String imageUrl) async {
    setState(() {
      _imageUrl = imageUrl;
      _hasErrorLoadingImage = false;
    });
    if (_imageUrl.isNotEmpty) {
      setState(() {
        _loadingImage = true;
      });
      await precacheImage(
        NetworkImage(_imageUrl),
        context,
        onError: (_, __) {
          if (!_loadingImage) {
            return;
          }
          setState(() {
            _loadingImage = false;
            _hasErrorLoadingImage = true;
          });
        },
      );
      setState(() {
        _loadingImage = false;
      });
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    Provider.of<Products>(
      context,
      listen: false,
    ).addProduct(_editedProduct);

    Navigator.of(context).pop();
  }

  Widget _imageBuilder() {
    if (_imageUrl.isEmpty) {
      return Center(
        child: Text(
          'Enter a URL',
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_loadingImage) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_hasErrorLoadingImage) {
      return Stack(
        children: [
          FittedBox(
            child: Icon(
              Icons.close,
              size: 100,
              color: Theme.of(context).errorColor,
            ),
          ),
          Center(
            child: Container(
              color: Colors.white70,
              child: Text(
                'No Image!',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return FittedBox(
      child: Image.network(_imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: null,
                      title: newValue,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a \'Title\'.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    helperText: ' ',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(newValue),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a \'Price\'.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0.0) {
                      return 'Please enter a number greater than 0.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    helperText: ' ',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: newValue,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a \'Description\'.';
                    }
                    if (value.length < 10) {
                      return 'Should have at least 10 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    helperText: ' ',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: _imageBuilder(),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        color: Colors.grey[100],
                      ),
                      constraints: BoxConstraints(
                        minHeight: 100.0,
                        minWidth: 100.0,
                        maxWidth: 100.0,
                        maxHeight: 100.0,
                      ),
                      margin: const EdgeInsets.only(
                        top: 8.0,
                        right: 10.0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: newValue,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an \'Image URL\'.';
                          }
                          if (_loadingImage) {
                            return 'Please wait a moment! The image is currently loading...';
                          }
                          if (_hasErrorLoadingImage) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onChanged: _updateImageUrl,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    ),
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
