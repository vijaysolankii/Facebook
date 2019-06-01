import 'package:flutter/material.dart';
import 'package:hack19/data/registration_data.dart';
import 'package:hack19/login.dart';
import 'package:hack19/main_page.dart';

import 'modules/registration_presenter.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'registration-page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> implements RegistrationViewContract{
  RegistrationPresenter _presenter;

  String _name,_password,_cpassword, _email;
  bool giris;
  bool _isLoading;
  _RegisterPageState() {
    _presenter = new RegistrationPresenter(this);
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/icon.png'),
                      width: 120.0,
                      height: 120.0,
                    ),
                    
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Registration',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                             validator: (str) =>
                                 str.isEmpty ? 'Insert name' : null,
                             onSaved: (str) => _name = str,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person,
                                color: Colors.blueAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFFFF),
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: 'Enter Your Name',
                              hintStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16.0,
                                fontFamily: 'Josefin',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            validator: (str) =>
                            !str.contains('@') ? 'Invalid E-Mail' : null,
                            onSaved: (str) => _email = str,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.mail,
                                color: Colors.blueAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFFFF),
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: 'serdar.plt21@gmail.com',
                              hintStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16.0,
                                fontFamily: 'Josefin',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                             validator: (str) => str.length < 7
                                 ? 'Invalid Password'
                                 : null,
                             onSaved: (str) => _password = str,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.blueAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFFFF),
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: 'Enter Your Password',
                              hintStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16.0,
                                fontFamily: 'Josefin',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.blueAccent,
                                padding:
                                    EdgeInsets.fromLTRB(46.0, 16.0, 46.0, 16.0),
                                child: Text(
                                  'Ready?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Josefin',
                                    fontSize: 22.0,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: () {
                                  var form = _formKey.currentState;

                                  if (form.validate()) {
                                    form.save();
                                    changeThePage(context);
                                  } else{
                                    print("error");
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Sign in !',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                onPressed: () {Navigator.of(context).pushNamed(LoginPage.tag);},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 90.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  changeThePage(BuildContext context) {
    print("name "+_name);
    print("_email "+_email);
    print("_password "+_password);
    _isLoading = true;
    _presenter.loadRegistration(_name,_email,_password,"");
  }
  @override
  void onLoadRegistrationComplete(RegistrationData items) {
    print("onLoadRegistrationComplete"+items.success);
    // TODO: implement onLoadRegistrationComplete
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(items.message),
    ));
    Navigator.of(context).pushNamed(LoginPage.tag);
  }

  @override
  void onLoadRegistrationError(String error) {
    print("onLoadRegistrationError "+error);
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(error),
    ));
    // TODO: implement onLoadRegistrationError
  }
}
