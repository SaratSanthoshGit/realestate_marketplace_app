import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seller Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Listings Overview'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Create Listing'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Messaging Inbox'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Analytics'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}