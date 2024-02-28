import 'package:flutter/material.dart';
import 'package:sit/Main application/connection.dart';
import 'package:sit/Main%20Application/post.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:sit/profile.dart';
import 'dart:ui';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _adminApproved = false;

  @override
  void initState() {
    super.initState();
    _fetchAdminApproval();
  }

  Future<void> _fetchAdminApproval() async {
    try {
      List<Map<String, dynamic>> userData =
          await DatabaseHelper.instance.getAllUserData();
      if (userData.isNotEmpty) {
        setState(() {
          _adminApproved = userData.first['admin_approved'] == 1;
        });
      }
    } catch (e) {
      print("Error fetching admin approval status: $e");
    }
  }

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
            icon: Icon(Icons.newspaper),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (!_adminApproved && index == 1) {
      // If admin approval is pending and PostPage is tapped
      _showAdminApprovalDialog(); // Show admin approval pending dialog
      return; // Do not proceed further
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAdminApprovalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Admin Approval Pending"),
          content:
              Text("Your admin approval is pending. Please wait for approval."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return ConnectionsPage();
      case 1:
        return _adminApproved ? PostPage() : _buildAdminApprovalPendingScreen();
      case 2:
        return ProfileApp();
      default:
        return ConnectionsPage();
    }
  }

  Widget _buildAdminApprovalPendingScreen() {
    return Stack(
      children: [
        // Blurred overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          blendMode: BlendMode.srcOver, // Set a valid blend mode
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Banner
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Admin Approval Pending",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
