import 'package:flutter/material.dart';

import 'data.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Bites'),
        actions: [
          // TODO block 4: replace this fixed 0 with the real cart count
          const Badge(
            label: Text('0'),
            child: Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          for (final dish in dishes)
            ListTile(
              title: Text(dish.name),
              trailing: Text('Rs ${dish.price}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(dish: dish),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
