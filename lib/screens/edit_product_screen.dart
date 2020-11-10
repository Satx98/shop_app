import 'package:flutter/material.dart';

class EditPoductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditPoductScreenState createState() => _EditPoductScreenState();
}

class _EditPoductScreenState extends State<EditPoductScreen> {
  var _imageUrl = '';
  var _hasErrorLoadingImage = false;
  var _loadingImage = false;

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
        onError: (error, stackTrace) {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onChanged: _updateImageUrl,
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
