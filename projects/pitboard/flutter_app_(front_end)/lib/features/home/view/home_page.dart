import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/state/auth_provider.dart';
import '../../auth/view/sign_in_page.dart';
import '../../../core/services/preferences_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    PreferencesService.isLocationEnabled().then((v) {
      if (mounted) setState(() => _locationEnabled = v);
    });
  }
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
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Welcome to the Pitboard abstracted showcase'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Enable location'),
                    value: _locationEnabled,
                    onChanged: (v) async {
                      await PreferencesService.setLocationEnabled(v);
                      if (mounted) setState(() => _locationEnabled = v);
                    },
                  )
                ],
              ),
      ),
    );
  }
}
