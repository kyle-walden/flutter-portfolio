import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/state/auth_provider.dart';
import '../../auth/view/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    // If signed out, redirect to sign-in page (defensive)
    if (!auth.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pitboard'),
        actions: [
          if (user != null)
            IconButton(
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
              },
            )
        ],
      ),
      body: Center(
        child: user == null
            ? ElevatedButton(
                child: const Text('Sign in'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                },
              )
            : const Text('Welcome to the Pitboard abstracted showcase'),
      ),
    );
  }
}
