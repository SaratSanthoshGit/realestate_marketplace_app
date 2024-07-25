import 'package:flutter/material.dart';
import 'listings_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Advanced Filters'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Save Search'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Search Results'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}