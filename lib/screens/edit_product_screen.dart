import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

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
  // GlobalKey is rarely used but used for Forms to interact with them from
  // inside the widget
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavourite: false,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = false;

  // Remember cannot access context in initS so using didChangeDependecies as
  // it exists after context is built and ready BUT before the build method is run.
  // Using a initflag to make sure that widget is not overly rebuilt everytime
  // dependecies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // If productId is true, then
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          // Textinputs only work with strings, so need to convert price to string
          'price': _editedProduct.price.toString(),
          // can't use controllers and initial values - have to pick one
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _saveForm() {
    // triggers all the the form fields validate callbacks
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    // triggers all the the form fields save callbacks
    _form.currentState.save();

    // Again, listen is false b/c not interested in updates in this widget -
    // only wanting to dispatch an action
    final products = Provider.of<ProductsProvider>(context, listen: false);

    var productAlreadyHasId = _editedProduct.id != null;

    if (productAlreadyHasId) {
      products.updateProduct(_editedProduct);
    } else {
      products.addProduct(_editedProduct);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      // Form is a special widget that encapsulates input fields, validation,
      // and everything that has to do with collecting user input. Also provides
      // ALOT of helpful configuration. Better for managing complex inputs than
      // manually managing/validating your own textcontrollers
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
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
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  // When the "enter" button is pressed
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  // A return of null means input passes validation
                  // A return of String means input does not pass and String will
                  // be automatically served as validation error message.
                  // But can manually config error message and style in textformfields
                  // InputDecoration
                  validator: (valueUserEntered) {
                    if (valueUserEntered.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  // Every input has its own onsaved method. Here we tell the
                  // method to over write just the property it collects input for
                  onSaved: (valueUserEntered) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: valueUserEntered,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  validator: (valueUserEntered) {
                    if (valueUserEntered.isEmpty) {
                      return 'Please enter a price';
                    }
                    // tryParse doesn't throw an error if value can't be
                    // parsed into a number. Will instead silently return null
                    if (double.tryParse(valueUserEntered) == null) {
                      return 'Please enter a number';
                    }
                    if (double.parse(valueUserEntered) <= 0) {
                      return 'Please enter a number greater than 0';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (valueUserEntered) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(valueUserEntered),
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (valueUserEntered) {
                    if (valueUserEntered.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (valueUserEntered.length < 10) {
                      return 'Please make description longer than 10 characters';
                    }
                    return null;
                  },
                  onSaved: (valueUserEntered) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: valueUserEntered,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
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
                        validator: (valueUserEntered) {
                          // TODO: Should also add these validations to the preview image
                          // imageUrlConroller to prevent an error
                          if (valueUserEntered.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!valueUserEntered.startsWith('http') &&
                              !valueUserEntered.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!valueUserEntered.endsWith('.png') &&
                              !valueUserEntered.endsWith('.jpg') &&
                              !valueUserEntered.endsWith('.jpeg')) {
                            return 'Please enter a URL for an image';
                          }
                          // Can beef this up with complex RegEx
                          return null;
                        },
                        // force a setstate re-render when user leaves the
                        // text input
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (valueUserEntered) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: valueUserEntered,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },

                        // Since this input is the last - making a decision to
                        // have the "return" button automatically submit the form
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
