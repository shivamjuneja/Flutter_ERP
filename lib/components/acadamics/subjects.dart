import 'package:flutter/material.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();

  String _subjectType = "Theory";

  List<Map<String, dynamic>> subjects = [
    {"name": "ENGLISH", "code": "", "type": "Theory"},
    {"name": "HINDI", "code": "", "type": "Theory"},
    {"name": "MATHS", "code": "", "type": "Theory"},
    {"name": "SCIENCE", "code": "", "type": "Theory"},
    {"name": "SOCIAL SCIENCE", "code": "", "type": "Theory"},
  ];

  void addSubject() {
    if (_subjectNameController.text.isEmpty) return;

    setState(() {
      subjects.add({
        "name": _subjectNameController.text,
        "code": _subjectCodeController.text,
        "type": _subjectType,
      });
    });

    _subjectNameController.clear();
    _subjectCodeController.clear();
  }

  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Subjects"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Subject Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Subject",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subject Name
                    TextField(
                      controller: _subjectNameController,
                      decoration: const InputDecoration(
                        labelText: "Subject Name *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Radio Buttons
                    Row(
                      children: [
                        Radio(
                          value: "Theory",
                          groupValue: _subjectType,
                          onChanged: (value) {
                            setState(() {
                              _subjectType = value.toString();
                            });
                          },
                        ),
                        const Text("Theory"),
                        const SizedBox(width: 20),
                        Radio(
                          value: "Practical",
                          groupValue: _subjectType,
                          onChanged: (value) {
                            setState(() {
                              _subjectType = value.toString();
                            });
                          },
                        ),
                        const Text("Practical"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Subject Code
                    TextField(
                      controller: _subjectCodeController,
                      decoration: const InputDecoration(
                        labelText: "Subject Code",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: addSubject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  const Color(0xFFB71C1C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Subject List
            const Text(
              "Subject List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final item = subjects[index];

                  return Column(
                    children: [
                      ListTile(
                        title: Text(item["name"]),
                        subtitle: Text(
                            "Code: ${item["code"]}     Type: ${item["type"]}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: const Color(0xFFB71C1C)),
                          onPressed: () => deleteSubject(index),
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
