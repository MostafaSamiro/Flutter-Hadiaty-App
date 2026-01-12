import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:holidate/Views/ContentsViews/GiftDetailsView.dart';
import 'package:holidate/Views/ContentsViews/ListEventeView.dart';
import 'package:holidate/Views/LoginProcess/SignUpView.dart';

import 'package:holidate/Views/NavBar/GiftPageView.dart';
import 'package:holidate/Views/NavBar/NavBarView.dart';
import 'package:holidate/Views/Welcome/WelcomeView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Views/LoginProcess/CompleteDataview.dart';
import 'Views/LoginProcess/LoginView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLoggedIn ? GNavExample() : Welcome(),
          routes: {
            'login': (context) => Login(),
            'signup': (context) => SignUp(),
            'welcome': (context) => Welcome(),
            'home': (context) => GNavExample(),
            'lEvents' : (context) => ListEvents(),
            'giftD' : (context) => GiftDetails(),
            'CompleteD' :(context) => CompleteData(),
          },
        );
      },
    );
  }
}
