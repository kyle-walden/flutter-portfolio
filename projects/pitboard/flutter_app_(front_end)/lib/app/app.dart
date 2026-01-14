import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/history/state/history_provider.dart';
import '../features/auth/state/auth_provider.dart';
import '../features/home/view/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()..load()),
      ],
      child: MaterialApp(
        title: 'Pitboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
