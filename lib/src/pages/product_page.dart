import 'package:flutter/material.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class  ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();

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
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
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
       keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
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

  void submit() {
    if(formKey.currentState.validate()) return
    print('todo ok');
  }
}