import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isloading = false;
  final _auth = FirebaseAuth.instance;
  void _submitFn(String email, String password, String username, bool isLogin,
      BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final userid = user.uid;
        // final userName =
        //     Firestore.instance.collection('users').document(userid).get();
        print("userId=" + userid);

        Provider.of<User>(context, listen: false).setUserId(userid);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'userImage': Null,
        });
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final userid = user.uid;
        print("userId=" + userid);
        Provider.of<User>(context, listen: false).setUserId(userid);
      }
    } on PlatformException catch (err) {
      var message = 'There was an error while authenticating';
      if (err.message != null) {
        message = err.message;
      }
      setState(() {
        _isloading = false;
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (err) {
      print(err);

      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/screenshot(213).jpeg'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AuthForm(_submitFn, _isloading),
            ),
          ],
        ),
      ),
    );
  }
}
