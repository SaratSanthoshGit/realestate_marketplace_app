import 'package:flutter/material.dart';
import 'seller_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: ElevatedButton(
          child: Text('Seller Dashboard'),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerDashboardScreen())),
        ),
      ),
    );
  }
}