import 'package:custom_bottom_nav/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _screens = [
    Scaffold(backgroundColor: Colors.cyan),
    Scaffold(backgroundColor: Colors.red),
    Scaffold(backgroundColor: Colors.yellow),
    Scaffold(backgroundColor: Colors.orange),
  ];
  final List<Widget> _icons = [
    Icon(
      Icons.person,
    ),
    Icon(
      Icons.shopping_basket,
    ),
    Icon(
      Icons.location_on,
    ),
    Icon(Icons.archive),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: List.generate(
          _screens.length,
          (index) => Offstage(
            offstage: _currentIndex != index,
            child: _screens[index],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        onChanged: ({index}) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _icons,
      ),
    );
  }
}
