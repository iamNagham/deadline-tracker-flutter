import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String selectedType = "Exam";
  List<String> types = ["Exam", "Project", "Quiz", "Presentation", "Assignment"];
  String titleError = "";
  String dateError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFECAAC2),
        title: Text("Add Deadline"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),

              DropdownButton(
                value: selectedType,
                items: types.map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title, color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  labelText: "Title",
                  fillColor: Color(0xFFEEBFD1),
                  filled: true,
                ),
              ),
              if (titleError != "")
                Text(titleError,
                    style: TextStyle(
                        color: Color(0xFFEEBFD1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  labelText: "Date",
                  fillColor: Color(0xFFDABBE0),
                  filled: true,
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      dateController.text =
                      "${picked.day}-${picked.month}-${picked.year}";
                    });
                  }
                },
              ),
              if (dateError != "")
                Text(dateError,
                    style: TextStyle(
                        color: Color(0xFFDABBE0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              TextFormField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "Notes (Optional)",
                  hintText: "Add any extra details...",
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF93AECA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(15),
                ),
                onPressed: () async {
                  setState(() {
                    titleError = "";
                    dateError = "";
                    if (titleController.text == "") {
                      titleError = "Title is required";
                    }
                    if (dateController.text == "") {
                      dateError = "Date is required";
                    }
                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    if (titleController.text != "" && dateController.text != "") {
                      FirebaseFirestore.instance.collection('deadlines').add({
                        "title": titleController.text,
                        "type": selectedType,
                        "date": dateController.text,
                        "notes": notesController.text,
                        "userId": uid,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Deadline added successfully"),
                            backgroundColor: Color(0xFF93AECA)),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill title and date")),
                      );
                    }
                  });
                },
                child: Text("Save Deadline"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}