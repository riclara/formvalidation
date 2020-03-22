import 'package:flutter/material.dart';
// import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(),
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
}
