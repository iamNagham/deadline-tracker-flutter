import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditDeadlinePage.dart';
import 'HomePage.dart';
class DeadlineDetails extends StatefulWidget {
  final String docId;
  final String title;
  final String type;
  final String date;
  final String note;

  DeadlineDetails({
    required this.docId,
    required this.title,
    required this.type,
    required this.date,
    required this.note,
  });

  @override
  State<DeadlineDetails> createState() => _DeadlineDetailsState();
}

class _DeadlineDetailsState extends State<DeadlineDetails> {
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

  @override
  Widget build(BuildContext context) {
    int days = daysLeft(widget.date);
    return Scaffold(
      appBar: AppBar(
        title: Text("Radar Details"),
        backgroundColor: Color(0xFFECAAC2),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFEEBFD1).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFEEBFD1), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFECAAC2))),
                  Divider(color: Color(0xFFECAAC2)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.label_important, color: Color(0xFF93AECA)),
                      SizedBox(width: 10),
                      Text("Type: " + widget.type,
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Date: " + widget.date, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Text("$days Days Left",
                      style: TextStyle(
                          color: Color(0xFFDABBE0),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Notes:",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFECAAC2))),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: Text(widget.note, style: TextStyle(fontSize: 16)),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPage(
                              docId: widget.docId,
                              title: widget.title,
                              date: widget.date,
                              type: widget.type,
                              notes: widget.note,
                            )),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text("Edit"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF93AECA)),
                  ),
                ),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("deadlines")
                          .doc(widget.docId)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Deleted Successfully!"),
                            backgroundColor: Color(0xFFDABBE0)),
                      );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text("Delete"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDABBE0)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
