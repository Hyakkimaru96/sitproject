import 'package:flutter/material.dart';
import 'package:sit/Main application/connection.dart';
import 'package:sit/profile.dart';
import 'package:sit/Main application/post.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Posts',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return ConnectionsPage();
      case 1:
        return ProfileApp();
      case 2:
        return PostPage();
      default:
        return ConnectionsPage(); // Set a default page
    }
  }
}
