import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Test Firebase Connection'),
              onPressed: () async {
                try {
                  await _firebaseService.addListing({'test': 'data'});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully connected to Firebase!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to connect to Firebase: $e')),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Listing App',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}