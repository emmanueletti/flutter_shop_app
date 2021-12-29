import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);

  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Manually managing focus
  // IMPORTANT: need to dispose of focusNodes
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      // Form is a special widget that encapsulates input fields, validation,
      // and everything that has to do with collecting user input. Also provides
      // ALOT of helpful configuration. Better for managing complex inputs than
      // manually managing/validating your own textcontrollers
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          // Using a singlechildscrollview + column vs a listview b/c
          // For very long forms (i.e. many input fields) OR in landscape mode (i.e. less
          // vertical space on the screen), you might encounter a strange behavior: User input
          // might get lost if an input fields scrolls out of view.
          // That happens because the ListView widget dynamically removes and re-adds widgets
          // as they scroll out of and back into view.

          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  // When the "enter" button is pressed
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      // Textformfield takes as much width as it can get and
                      // insude a Row - which will expand as wide as its children
                      // need - we will need a confined container
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        // Normally don't have to manage controllers / the form
                        // inputs when using the Form widget - but here we want
                        // to show an image preview and so will need access to
                        // form value
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        // force a setstate re-render when user leaves the
                        // text input
                        onEditingComplete: () {
                          setState(() {});
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
