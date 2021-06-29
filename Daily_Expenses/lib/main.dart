import 'package:flutter/material.dart';
import './transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  final List<Transaction> transaction = [

    Transaction(
      id: 'p1',
      title: 'Shoes',
      amount: 969.4,
      date: DateTime.now(),
    ),

    Transaction(
      id: 'p2',
      title: 'Bags',
      amount: 19.4,
      date: DateTime.now(),
    ),

  ],

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Routine Apps'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
              color: Colors.yellow,
              child: Text('Chart!'),
              elevation: 5,
            ),
          ),
          Card(
            child: Text('List of items.'),
          ),
        ],
      ),
    );
  }
}
