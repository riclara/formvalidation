import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product.model.dart';
import 'package:formvalidation/src/preferences/UserPreferences.dart';
import 'package:formvalidation/src/providers/product.provider.dart';
// import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productProvider = ProductProvider();

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              prefs.removeToken();
              Navigator.of(context).pushReplacementNamed('login');
            }
          ),
        ],
      ),
      body: _buildProductList(context),
      floatingActionButton: _buildButton(context),
    );
  }

  Widget _buildButton (BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'product'),
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add),
    );
  }

  Widget _buildProductList (BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: productProvider.getProducts(context),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
            return _buildItem(context, snapshot.data[index]);
           },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, ProductModel prod) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productProvider.deleteProduct(prod.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (prod.photoUrl == null) ? 
              Image(image: AssetImage('assets/no-image.png')) :
              FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(prod.photoUrl),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text('${prod.title} - ${prod.value}'),
                subtitle: Text(prod.id),
                onTap: () => Navigator.pushNamed(context, 'product', arguments: prod),
              )
          ],
        ),
      ),
    );
  }
}

