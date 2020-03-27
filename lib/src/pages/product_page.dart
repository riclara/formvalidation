import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/product_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/product.model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class  ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductModel product = ProductModel();
  bool _disableButton = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    final productBloc = Provider.productBloc(context);

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _getImage(ImageSource.gallery)
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _getImage(ImageSource.camera)
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
                _showPhoto(),
                _buildName(),
                _buildPrice(),
                _buildSwitchAvailable(),
                _buildButton(productBloc)
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
      onChanged: (value) => product.title = value,
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
      onChanged: (value) => product.value = double.parse(value),
      validator: (value) {
        String msg;
        if (!utils.isNumeric(value)) {
          msg =  'Debe ser un número';
        }
        return msg;
      },
    );
  }

  Widget _buildButton(ProductBloc bloc) {
    return RaisedButton.icon(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      onPressed: (_disableButton) ? null : () => submit(bloc),
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

  void _showSnackBar (String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1500),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void submit(ProductBloc bloc) async {
    setState(() {
      _disableButton = true;
    });

    if(formKey.currentState.validate()) {
      if (photo != null) {
        print('into photo');
        product.photoUrl = await bloc.uploadPhoto(photo);
      }

      if (product.id == null) {
        bloc..addProduct(product);
      }
      else bloc.updateProduct(product);
    }
    _showSnackBar('Producto Guardado');
    setState(() {
      _disableButton = false;
    });
    Navigator.pop(context, true);
  }

  Widget _showPhoto() {
    if(product.photoUrl != null && photo == null){
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(product.photoUrl),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _getImage(ImageSource source) async{
    photo = await ImagePicker.pickImage(
      source: source)
    ;
    if (photo == null) {

    }
    setState(() {
      
    });
  }
}
