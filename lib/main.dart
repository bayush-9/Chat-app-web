import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/group_details_screen.dart';
import 'package:chat_app/screens/navigation_screen.dart';
import 'package:chat_app/screens/new_group_form.dart';
import 'package:chat_app/screens/proxy_managing_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<int, Color> color = {1: Color.fromARGB(255, 242, 101, 121)};
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Groups(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            iconTheme: IconThemeData(color: Colors.blue),
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            dialogTheme: DialogTheme(
                backgroundColor: Colors.grey[900],
                titleTextStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
          ),
          home: StreamBuilder(
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot.hasData) {
                final data = userSnapshot.data;
                print(data);
                return NavigationScreen();
              } else {
                return AuthScreen();
              }
            },
            stream: FirebaseAuth.instance.onAuthStateChanged,
          ),
          routes: {
            NewGroupForm.routeName: (context) => NewGroupForm(),
            ChatScreen.routeName: (context) => ChatScreen(),
            GroupDetails.routeName: (context) => GroupDetails(),
            ProxyManagementScreen.routeName: (context) =>
                ProxyManagementScreen(),
          }),
    );
  }
}
