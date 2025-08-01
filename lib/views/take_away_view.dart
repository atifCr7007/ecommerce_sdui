import 'package:flutter/material.dart';

class TakeAwayView extends StatelessWidget {
  const TakeAwayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.takeout_dining,
              size: 64,
              color: Colors.green[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Take Away',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Order and pickup from nearby restaurants',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
