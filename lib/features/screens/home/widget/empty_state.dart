import 'package:flutter/material.dart';
import 'package:smart_patrol/utils/styles/colors.dart';

class EmptyStateWidget extends Center {
  EmptyStateWidget({super.key, String label = ''})
      : super(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 100,
              color: kOxfordBlue,
            ),
            const SizedBox(height: 10),
            Text(
              'Your $label Not Available at this Shift...',
              style: const TextStyle(color: kGreyLight),
            ),
            const SizedBox(height: 20),
            // const Text('Please Retry', style: TextStyle(color: kGreyLight))
          ],
        ));
}
