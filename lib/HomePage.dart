import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project10/DeadlineDetailsPage.dart';
import 'package:project10/LoginPage.dart';
import 'firebase_options.dart';
import 'AddDeadlinePage.dart';
import 'EditDeadlinePage.dart';
import 'ProfilePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int daysLeft(String date) {
    if (date == "") return 0;
    try {
      var num = date.split("-");
      var d = DateTime(int.parse(num[2]), int.parse(num[1]), int.parse(num[0]));
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day);
      return d.difference(today).inDays;
    } catch (e) {
      return 0;
    }
  }

  Icon icons(String type) {
    if (type == "Exam") return Icon(Icons.school);
    if (type == "Project") return Icon(Icons.work);
    if (type == "Quiz") return Icon(Icons.edit_note);
    if (type == "Presentation") return Icon(Icons.mic);
    return Icon(Icons.assignment);
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFECAAC2),
        title: Text("Student Deadline Radar"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LogIn()),
                    (route) => false,
              );
            },
            icon: Icon(Icons.logout),

          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },

              icon: Icon(Icons.person))
        ],
      ),
      body: StreamBuilder(

        stream: FirebaseFirestore.instance.collection('deadlines').where('userId', isEqualTo: uid).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: Text("loading..."));

          List fetchedList = snap.data!.docs;
          fetchedList.sort((a, b) {
            return daysLeft(a['date']).compareTo(daysLeft(b['date']));
          });

          return ListView.builder(
            itemCount: fetchedList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeadlineDetails(
                        docId: fetchedList[index].id,
                        title: fetchedList[index]['title'],
                        date: fetchedList[index]['date'],
                        type: fetchedList[index]['type'],
                        note: fetchedList[index]['notes'] ?? "" ,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFBED1E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          icons(fetchedList[index]['type']),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fetchedList[index]['title']),
                              Text(fetchedList[index]['type']),
                            ],
                          ),
                        ],
                      ),
                      Text("${daysLeft(fetchedList[index]['date'])} days left"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF93AECA),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
      ),
    );
  }
}