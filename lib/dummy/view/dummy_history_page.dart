import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_patrol/utils/utils.dart';

class DummyHistoryPage extends StatelessWidget {
  const DummyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: AppUtil.height,
        width: AppUtil.width,
        child: const Center(
          child: Text(
            'History Page',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ));
  }
}
