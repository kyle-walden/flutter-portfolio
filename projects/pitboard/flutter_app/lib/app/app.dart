import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/history/viewmodel/history_viewmodel.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/home/viewmodel/location_viewmodel.dart';
import '../features/home/view/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()..load()),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: MaterialApp(
        title: 'Pitboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
