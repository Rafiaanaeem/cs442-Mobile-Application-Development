import 'package:flutter/material.dart';

import 'data.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.dish});

  final Dish dish;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // This number belongs to THIS screen only.
  int _added = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
        // TODO block 4: show the cart icon here too
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rs ${widget.dish.price}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            Text('Added on this screen: $_added'),
            const SizedBox(height: 16),
            ElevatedButton(
              // TODO block 4: add to the shared cart instead
              onPressed: () => setState(() => _added++),
              child: const Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}
