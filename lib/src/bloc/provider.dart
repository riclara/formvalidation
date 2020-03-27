import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/product_bloc.dart';

class Provider extends InheritedWidget{
  static Provider _instance;

  final _loginBloc = LoginBloc();
  final _productBloc = ProductBloc();

  factory Provider ({Key key, Widget child}) {
    if (_instance == null) {
      _instance = Provider._internal(key: key, child: child,);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static ProductBloc productBloc (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productBloc;
  }
}