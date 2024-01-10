import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.eventMessage = 'Loading...'});

  final String eventMessage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 6.0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16.0),
            Text(eventMessage),
          ],
        ),
      ),
    );
  }
}
