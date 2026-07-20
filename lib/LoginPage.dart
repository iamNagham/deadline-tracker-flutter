import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'SignUpPage.dart';
class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> signinm() async {
    if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Email is empty!!"),
            backgroundColor: Color(0xFFDABBE0)),
      );
      return false;
    }
    if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Password is empty!!"),
            backgroundColor: Color(0xFFDABBE0)),
      );
      return false;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Correct!!"),
            backgroundColor: Color(0xFF93AECA)),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Wrong!!"),
            backgroundColor: Color(0xFFDABBE0)),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.radar, size: 80, color: Color(0xFFECAAC2)),
              Text("Student Radar",
                  style: TextStyle(fontSize: 24, color: Color(0xFF93AECA))),
              SizedBox(height: 20),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Color(0xFFECAAC2)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFECAAC2)),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    bool success = await signinm();
                    if (success) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF93AECA)),
                  child: Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text("No Account, Create Now!!",
                    style: TextStyle(
                        color: Color(0xFFECAAC2),
                        fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
