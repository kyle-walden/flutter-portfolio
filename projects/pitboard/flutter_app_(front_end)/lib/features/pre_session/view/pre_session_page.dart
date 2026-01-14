import 'package:flutter/material.dart';
import '../widgets/map_widget.dart';

class PreSessionPage extends StatelessWidget {
  const PreSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Token intentionally not stored in repo. Provide via runtime when running.

    return Scaffold(
      appBar: AppBar(title: const Text('Pre-session')),
      body: Column(
        children: [
          Expanded(child: FullMap()),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Pre-session controls go here (map-based location, participants, etc.)'),
          )
        ],
      ),
    );
  }
}
