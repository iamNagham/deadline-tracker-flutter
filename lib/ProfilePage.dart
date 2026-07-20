import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;
  String userEmail = "";
  String userName = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? "No email";
    userName = userEmail.split('@')[0];

    final currentTheme = MyApp.of(context)?.themeMode;
    _isDarkMode = currentTheme == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFFECAAC2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF93AECA),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 15),
            Text(
              userName,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFECAAC2)),
            ),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: Color(0xFF93AECA)),
                    title: Text("Dark Mode"),
                    trailing: Switch(
                      value: _isDarkMode,
                      activeColor: Color(0xFFDABBE0),
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        MyApp.of(context)?.toggleTheme(value);
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Color(0xFF93AECA)),
                    title: Text("Help & Support"),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Spacer(),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDABBE0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LogIn()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
