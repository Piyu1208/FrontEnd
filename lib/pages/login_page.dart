import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free/pages/colors.dart'; // assuming you have kPrimaryBlue etc.

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isLogin = true;

  // Future<void> _authenticate() async {
  //   try {
  //     if (isLogin) {
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _email.text.trim(),
  //         password: _password.text.trim(),
  //       );
  //     } else {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //         email: _email.text.trim(),
  //         password: _password.text.trim(),
  //       );

  //       final baseName = _email.text.trim().split('@')[0];
  //       final timestampSuffix = DateTime.now().millisecondsSinceEpoch % 100000;
  //       final generatedUsername = "${baseName}_$timestampSuffix";

  //       // Print or pass the username wherever needed
  //       print("Generated username: $generatedUsername");

  //       // Optional: Store or forward this for your Firestore logic
  //       // e.g., context.read<UserProvider>().setUsername(generatedUsername);
  //     }
  //   } catch (e) {
  //     print('Auth error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }

  // Future<void> _authenticate() async {
  //   try {
  //     if (isLogin) {
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _email.text.trim(),
  //         password: _password.text.trim(),
  //       );
  //     } else {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //             email: _email.text.trim(),
  //             password: _password.text.trim(),
  //           );

  //       final baseName = _email.text.trim().split('@')[0];
  //       final timestampSuffix = DateTime.now().millisecondsSinceEpoch % 100000;
  //       final generatedUsername = "${baseName}_$timestampSuffix";

  //       final user = userCredential.user;

  //       // Save to Firestore
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user!.uid)
  //           .set({
  //             'email': _email.text.trim(),
  //             'username': generatedUsername,
  //             'createdAt': Timestamp.now(),
  //           });

  //       print("Username saved: $generatedUsername");
  //     }
  //   } catch (e) {
  //     print('Auth error: $e');
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  //   }
  // }

  Future<void> _authenticate() async {
    try {
      if (isLogin) {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _email.text.trim(),
              password: _password.text.trim(),
            );

        final user = userCredential.user;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists && userDoc.data()!.containsKey('username')) {
            final fetchedUsername = userDoc['username'];
            print('Welcome back, $fetchedUsername!');
            // You can now use fetchedUsername wherever needed
          } else {
            print('No username found for this user.');
          }
        }
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _email.text.trim(),
              password: _password.text.trim(),
            );

        // final user = userCredential.user;
        // if (user != null) {
        //   final baseName = _email.text.trim().split('@')[0];
        //   final timestampSuffix =
        //       DateTime.now().millisecondsSinceEpoch % 100000;
        //   final generatedUsername = "${baseName}_$timestampSuffix";

        //   await FirebaseFirestore.instance
        //       .collection('users')
        //       .doc(user.uid)
        //       .set({
        //         'email': _email.text.trim(),
        //         'username': generatedUsername,
        //         'createdAt': Timestamp.now(),
        //       });

        //   print("Username created: $generatedUsername");
        // }

        final user = userCredential.user;
        if (user != null) {
          final adjectives = ['Brave', 'Happy', 'Silly', 'Chill', 'Clever'];
          final animals = ['Panda', 'Koala', 'Fox', 'Otter', 'Lion'];

          String generatedUsername = '';
          bool isUnique = false;

          final random = DateTime.now().millisecondsSinceEpoch;

          for (int i = 0; i < 10; i++) {
            final adjective = adjectives[random % adjectives.length];
            final animal = animals[(random + i) % animals.length];
            final suffix = (random + i) % 1000; // Optional numeric suffix

            final candidate = '$adjective$animal$suffix';

            // Check if username already exists
            final result = await FirebaseFirestore.instance
                .collection('users')
                .where('username', isEqualTo: candidate)
                .limit(1)
                .get();

            if (result.docs.isEmpty) {
              generatedUsername = candidate;
              isUnique = true;
              break;
            }
          }

          if (!isUnique) {
            generatedUsername = 'User${random % 100000}';
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'email': _email.text.trim(),
                'username': generatedUsername,
                'createdAt': Timestamp.now(),
              });

          print("Cute username created: $generatedUsername");
        }
      }
    } catch (e) {
      print('Auth error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBlue, // your app's primary color
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Login' : 'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isLogin ? 'Login' : 'Register'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? 'Don’t have an account? Register'
                          : 'Already have an account? Login',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
