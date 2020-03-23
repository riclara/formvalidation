import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product.model.dart';
import 'package:formvalidation/src/providers/product.provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class  ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final productProvider = ProductProvider();


  ProductModel product = ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {}
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _buildName(),
                _buildPrice(),
                _buildSwitchAvailable(),
                _buildButton()
              ],
            )
            ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => product.title = value,
      validator: (value) {
        String msg;
        if (value.length < 3) {
          msg =  'Ingrese el nombre del producto';
        } 
        return msg;
      },
    );
  }

  Widget _buildPrice() {
     return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        String msg;
        if (!utils.isNumeric(value)) {
          msg =  'Debe ser un número';
        }
        return msg;
      },
    );
  }

  Widget _buildButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      onPressed: submit,
      icon: Icon(Icons.save),
      label: Text('Guardar')
      );
  }

  Widget _buildSwitchAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Disponible'),
      onChanged: (value) => setState((){
        product.available = value;
      }),
      activeColor: Colors.deepPurpleAccent,
    );
  }

  void submit() {
    if(!formKey.currentState.validate()) return
    formKey.currentState.save();
    productProvider.createProduct(product);
  }
}