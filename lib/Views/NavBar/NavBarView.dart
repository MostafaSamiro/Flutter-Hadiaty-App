import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:holidate/Views/HomeView/HomeView.dart';
import 'package:holidate/Views/NavBar/GiftPageView.dart';
import 'package:holidate/Views/NavBar/ProfileView.dart';

class GNavExample extends StatefulWidget {
  @override
  _GNavExampleState createState() => _GNavExampleState();
}

class _GNavExampleState extends State<GNavExample> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    GiftPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240,
              height: 74,
              decoration: BoxDecoration(
                color: Color(0xff8E7DBE),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GNav(
                gap: 8,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                activeColor: Color(0xff8E7DBE),
                color: Colors.white,
                tabBackgroundColor: Colors.white,
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.card_giftcard, text: 'Gifts'),
                  GButton(icon: Icons.person, text: 'Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
