import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/history_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                final item = provider.items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                );
              },
            ),
    );
  }
}
