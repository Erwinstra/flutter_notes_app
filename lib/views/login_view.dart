import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  void emailVerification() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Center(child: Text('Verify Your Email')),
            content: const Text(
              'Your email isn\'t verified yet, you need to click the link on '
              'the email we already sent to you. Please click send email verification '
              'if that email is already expired.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService.firebase().sendEmailVerification();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } on GenericAuthException {
                    if (context.mounted) {
                      showErrorDialog(context, 'Authentication error');
                    }
                  }
                },
                child: const Text('Send email verification'),
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
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
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );

                  final user = AuthService.firebase().currentUser;

                  if (user?.isEmailVerified ?? false) {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, notesRoute);
                    }
                  } else {
                    return emailVerification();
                  }
                } on InvalidEmailAuthException {
                  context.mounted
                      ? await showErrorDialog(
                          context, 'This is an invalid email address')
                      : null;
                } on UserNotFoundAuthException {
                  context.mounted
                      ? await showErrorDialog(context, 'User Not Found')
                      : null;
                } on GenericAuthException {
                  context.mounted
                      ? await showErrorDialog(context, 'Authentication error')
                      : null;
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not register yet? '),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, registerRoute);
                  },
                  child: const Text(
                    'Register now',
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
      ),
    );
  }
}
