import 'package:flutter/material.dart';
import 'package:hack19/data/login_data.dart';
import 'package:hack19/main_page.dart';
import 'package:hack19/register.dart';

import 'modules/login_presenter.dart';
import 'utils/common.dart';
import 'utils/preference.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginViewContract {
  LoginPresenter _presenter;
  bool _isLoading;

  String _email, _sifre;
//  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool giris;
  _LoginPageState() {
    _presenter = new LoginPresenter(this);
//    _firebaseMessaging.getToken().then((token) {
//      print(token);
//      this.token = token;
//    });
  }
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                padding: const EdgeInsets.only(top: 30.0),
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
                      'Login',
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
                            controller: emailController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                             validator: (str) =>
                                 !str.contains('@') ? 'Invalid E-Mail' : null,
                             onSaved: (str) => _email = str,
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
                            controller: passwordController,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                             validator: (str) => str.length < 7
                                 ? 'Invalid Password'
                                 : null,
                             onSaved: (str) => _sifre = str,
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
                            height: 16.0,
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
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFFFF627C),
                                  ),
                                ),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          
                          FlatButton(
                            child: Text(
                              'Sign Up!',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(RegisterPage.tag);
                            },
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
    print(emailController.text);
    print(passwordController.text);
    _isLoading = true;
    _presenter.loadLogin(
        emailController.text, passwordController.text,"", "");
  }
  @override
  void onLoadLoginComplete(LoginData items) {
    print("onLoadLoginComplete ${items.u_name}");
    PreferenceManager().setPref(Common.USER_ID,items.u_id);
    PreferenceManager().setPref(Common.USER_NAME,items.u_name);
    PreferenceManager().setPref(Common.USER_EMAIL,items.u_email);
    PreferenceManager().setPref(Common.USER_IMAGE,items.u_image);

    Route route = MaterialPageRoute(builder: (context) => SocialHome());
    Navigator.pushReplacement(context, route);

  }

  @override
  void onLoadLoginError(String error) {
    print("onLoadLoginError ${error}");
    // TODO: implement onLoadLoginError
  }
}


