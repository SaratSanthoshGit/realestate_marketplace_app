import 'package:flutter/material.dart';
import 'listing_details_screen.dart';
import 'favorites_screen.dart';

class ListingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Listing Details'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingDetailsScreen())),
            ),
            ElevatedButton(
              child: Text('Favorites'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen())),
            ),
            ElevatedButton(
              child: Text('Grid View'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('List View'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}