import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void registerCompleted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Success!'),
          content: const Text(
            'Successfully register an account! Please verify your email with the link we already sent to your email',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.firebase().sendEmailVerification();

                  if (context.mounted) {
                    Navigator.pop(context);
                    _email.clear();
                    _password.clear();
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    showErrorDialog(context, 'Authentication error');
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    _email.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase()
                        .createUser(email: email, password: password);
                    registerCompleted();
                  } on InvalidEmailAuthException {
                    context.mounted
                        ? showErrorDialog(
                            context, 'This is an invalid email address')
                        : null;
                  } on WeakPasswordAuthException {
                    context.mounted
                        ? showErrorDialog(context, 'Weak Password')
                        : null;
                  } on EmailAlreadyInUseAuthException {
                    context.mounted
                        ? showErrorDialog(context, 'Email is already in use')
                        : null;
                  } on GenericAuthException {
                    context.mounted
                        ? showErrorDialog(context, 'Authentication error')
                        : null;
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
