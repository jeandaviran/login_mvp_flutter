import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_mvp/data/local/database.dart';
import 'package:login_mvp/models/user.dart';
import 'package:login_mvp/pages/presenter/login_presenter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginContract {
  BuildContext _ctx;
  bool _isLoading = false;
  bool _isButtonDisabled = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username, _password;

  LoginPresenter _presenter;

  _LoginPageState() {
    _presenter = new LoginPresenter(this);
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, isEventDisabled);
  }

  void isEventDisabled(){
    setState(() {
      _isLoading = false;
      _isButtonDisabled = false;
    });
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        _isButtonDisabled = true;
        form.save();
        _presenter.doLogin(_username, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _isButtonDisabled ? null : _submit,
      child: new Text("Login"),
      color: Colors.green,
    );
    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Sqflite App Login",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              )
            ],
          ),
        ),
        loginBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: _isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : loginForm,
        ),
      ),
    );
  }

  @override
  void LoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
      startTime();
    });
  }

  @override
  void LoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
      startTime();
    });
    var db = new DatabaseHelper();
    await db.saveUser(user);
    Navigator.of(context).pushNamed("/home");
  }
}