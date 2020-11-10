import 'package:flutter/material.dart';

class EditPoductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditPoductScreenState createState() => _EditPoductScreenState();
}

class _EditPoductScreenState extends State<EditPoductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  var _hasErrorLoadingImage = false;
  var _loadingImage = false;

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  Future<void> _updateImageUrl() async {
    setState(() {
      _hasErrorLoadingImage = false;
    });
    if (_imageUrlController.text.isNotEmpty) {
      setState(() {
        _loadingImage = true;
      });
      await precacheImage(
        NetworkImage(_imageUrlController.text),
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
    if (_imageUrlController.text.isEmpty) {
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
      child: Image.network(_imageUrlController.text),
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
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
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
