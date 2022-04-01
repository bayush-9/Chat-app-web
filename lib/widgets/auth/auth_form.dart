import 'dart:io';
import 'package:chat_app/widgets/auth/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  bool isloading;
  AuthForm(this.submitFn, this.isloading);
  final Function(
    String email,
    String password,
    String username,
    bool islogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';
  bool _isLogin = true;
  File _userpickedImage;

  void _pickedImage(File image) {
    _userpickedImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    // if (_userpickedImage == null && !_isLogin) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("Please pick an image."),
    //     ),
    //   );
    //   return;
    // }
    if (!isValid) {
      return;
    } else {
      _formKey.currentState.save();
      widget.submitFn(
        _email.trim(),
        _password.trim(),
        _username.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 92, 225, 230),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-mail id'),
                  validator: (value) {
                    if (!(value == null) && value.contains('@')) {
                      return null;
                    } else {
                      return 'Please  enter valid email.';
                    }
                  },
                  onSaved: (newValue) => _email = newValue,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value.length < 5 || (value == null)) {
                        return 'Please enter larger username!';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) => _username = newValue,
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.length < 6 || (value == null)) {
                      return 'Please enter password larger than 6 characters!';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _password = newValue,
                ),
                SizedBox(
                  height: 10,
                ),
                widget.isloading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () {
                          _trySubmit();
                        },
                        child: Text(!_isLogin ? 'Signup' : 'Login'),
                      ),
                if (!widget.isloading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      !_isLogin ? 'Login Instead' : 'Create new account',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
