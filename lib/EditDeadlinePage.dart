import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final String docId;
  final String title;
  final String date;
  final String type;
  final String notes;

  const EditPage({
    super.key,
    required this.docId,
    required this.title,
    required this.date,
    required this.type,
    required this.notes,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController notesController;

  String selectedType = "Exam";
  List<String> types = ["Exam", "Project", "Quiz", "Presentation", "Assignment"];

  String titleError = "";
  String dateError = "";
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.title);
    dateController = TextEditingController(text: widget.date);
    notesController = TextEditingController(text: widget.notes);
    selectedType = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFECAAC2),
        title: const Text("Edit Deadline"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),

              DropdownButton(
                value: selectedType,
                items: types.map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Title",
                  fillColor: const Color(0xFFEEBFD1),
                  filled: true,
                ),
              ),
              if (titleError.isNotEmpty)
                Text(
                  titleError,
                  style: const TextStyle(
                    color: Color(0xFFEEBFD1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 10),

              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon:
                  const Icon(Icons.calendar_month, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Date",
                  fillColor: const Color(0xFFDABBE0),
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
              if (dateError.isNotEmpty)
                Text(
                  dateError,
                  style: const TextStyle(
                    color: Color(0xFFDABBE0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 10),

              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Notes (Optional)",
                  hintText: "Add any extra details...",
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF93AECA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: isUpdating
                    ? null
                    : () async {
                  setState(() {
                    titleError = "";
                    dateError = "";
                  });

                  if (titleController.text.isEmpty) {
                    setState(() {
                      titleError = "Title is required";
                    });
                    return;
                  }

                  if (dateController.text.isEmpty) {
                    setState(() {
                      dateError = "Date is required";
                    });
                    return;
                  }

                  setState(() {
                    isUpdating = true;
                  });

                  await FirebaseFirestore.instance
                      .collection('deadlines')
                      .doc(widget.docId)
                      .update({
                    "title": titleController.text,
                    "type": selectedType,
                    "date": dateController.text,
                    "notes": notesController.text,
                  });

                  Navigator.pop(context);
                },
                child: isUpdating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Deadline"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
