import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/user_provider.dart';
import 'package:formvalidation/src/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userProvider = UserProvider();

  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          _registerForm(context)
        ],
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
  final bloc = Provider.of(context);
  final size = MediaQuery.of(context).size;

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(child: Container(
          height: 180.0,
        )),
        Container(
          width: size.width * 0.85,
          padding: EdgeInsets.symmetric(vertical: 50.0),
          margin: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.0, 5.0),
                spreadRadius: 3.0
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text('Registrar', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 60.0),
              _buildEmail(bloc),
              SizedBox(height: 30.0),
              _buildPassword(bloc),
              SizedBox(height: 30.0),
              _buildButton(bloc)
            ],
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          child: Text('Ya tienes una cuenta?')
        ),
        SizedBox(height: 100.0,)
      ],
    )
  );
}

  Widget _buildEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'example@email.com',
              labelText: 'Correo electrónico',
              errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changeEmail(value),
          ),
        );
      },
    );

  
  }

  Widget _buildPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _buildButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        final Function fn = snapshot.hasData && !_disabled ? () => _register(context, bloc) : null;
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Enviar', style: TextStyle(color: Colors.white)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,

          onPressed: fn
        );
      });
  }

  Widget _buildBackground(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        ),
      )
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, left: -30.0, child: circle),
        Positioned(bottom: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Ricardo Lara', style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          ),
        )
        
      ],
    );
  }

  _register(BuildContext context, LoginBloc bloc) async{
    if (_disabled) return;
    _disabled = true;
    Map<String, dynamic> resp = await userProvider.newUser(bloc.email, bloc.password);
    if (resp['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlert(context, 'No hemos creado tu usuario');
    _disabled = false;

    }
  }
}

 



