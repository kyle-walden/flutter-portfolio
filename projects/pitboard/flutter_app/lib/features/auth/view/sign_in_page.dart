import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn(AuthViewModel auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.signIn(_emailController.text.trim(), _passwordController.text);
  }

  Future<void> _signUp(AuthViewModel auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.signUp(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || v.isEmpty) ? 'Email required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
              ),
              const SizedBox(height: 12),
              Consumer<AuthViewModel>(builder: (context, auth, _) {
                if (auth.error != null) return Text(auth.error!, style: const TextStyle(color: Colors.red));
                if (auth.isLoading) return const CircularProgressIndicator();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () => _signIn(auth), child: const Text('Sign in')),
                    ElevatedButton(onPressed: () => _signUp(auth), child: const Text('Sign up')),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
