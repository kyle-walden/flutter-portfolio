import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../auth/view/sign_in_page.dart';
import '../viewmodel/location_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
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
                    value: Provider.of<LocationViewModel>(context).enabled,
                    onChanged: (v) async {
                      // delegate to provider which handles permission & prefs
                      final provider = Provider.of<LocationViewModel>(context, listen: false);
                      await provider.toggle(v);
                      if (!provider.enabled) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Location permission denied or disabled'),
                        ));
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  Consumer<LocationViewModel>(builder: (_, lp, __) {
                    if (!lp.enabled) return const SizedBox.shrink();
                    if (lp.currentPosition == null) return const Text('Waiting for location...');
                    final pos = lp.currentPosition!;
                    return Text('Location: ${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}');
                  }),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
