import 'package:flutter/material.dart';

import '../model/business.dart';

class DetailScreen extends StatelessWidget {
  final Business business;
  const DetailScreen(this.business, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(business.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Location: ${business.location}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Contact: ${business.contact}',
              style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }
}
