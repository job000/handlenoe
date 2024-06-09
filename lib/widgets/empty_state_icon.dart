import 'package:flutter/material.dart';

class EmptyStateIcon extends StatelessWidget {
  const EmptyStateIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 100,
          color: Colors.grey,
        ),
        const SizedBox(height: 20),
        Text(
          'No Shopping Lists',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}
