import 'package:flutter/material.dart';

class SubjectGroupScreen extends StatefulWidget {
  const SubjectGroupScreen({super.key});

  @override
  State<SubjectGroupScreen> createState() => _SubjectGroupScreenState();
}

class _SubjectGroupScreenState extends State<SubjectGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _subjectScrollController = ScrollController();

  String? _selectedClass;
  String? _selectedSection;

  // Classes
  final List<String> _classList = [
    "Nursery", "LKG", "UKG", "1", "2", "3", "4", "5", 
    "6", "7", "8", "9", "10", "11", "12"
  ];

  // Sections
  final List<String> _sectionList = ["A", "B", "C", "D", "E", "F"];

  // Subjects checkbox list
  final Map<String, bool> _subjects = {
    "English Language": false,
    "Hindi Language": false,
    "Mathematics": false,
    "Science": false,
    "Social Science": false,
    "General Knowledge": false,
    "Computer Science": false,
    "Art & Drawing": false,
    "English Literature": false,
    "Hindi Literature": false,
    "Mathematics Lab": false,
    "Physics": false,
    "Chemistry": false,
    "Biology": false,
    "History": false,
    "Geography": false,
    "Civics": false,
    "Economics": false,
    "Business Studies": false,
    "Physical Education": false,
    "Music": false,
    "Dance": false,
    "Yoga": false,
    "Environmental Studies": false,
    "Value Education": false,
    "Sanskrit": false,
    "French": false,
    "German": false,
    "Spanish": false,
    "Robotics": false,
  };

  // List of created groups
  final List<Map<String, dynamic>> _subjectGroups = [];

  // Function to validate and add subject group
  void _addSubjectGroup() {
    if (_formKey.currentState!.validate()) {
      final selectedSubjects = _subjects.entries
          .where((e) => e.value == true)
          .map((e) => e.key)
          .toList();

      if (selectedSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one subject"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      _subjectGroups.add({
        "name": _nameController.text,
        "class": _selectedClass,
        "section": _selectedSection,
        "subjects": selectedSubjects,
        "description": _descriptionController.text,
        "createdAt": DateTime.now(),
      });

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _nameController.clear();
        _descriptionController.clear();
        _selectedClass = null;
        _selectedSection = null;
        _subjects.updateAll((key, value) => false);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Subject group added successfully"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteGroup(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Group"),
        content: Text("Are you sure you want to delete '${_subjectGroups[index]['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor:  const Color(0xFFB71C1C)),
            onPressed: () {
              Navigator.pop(context);
              final deletedName = _subjectGroups[index]['name'];
              _subjectGroups.removeAt(index);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Group '$deletedName' deleted"),
                  backgroundColor: const Color(0xFFB71C1C),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editGroup(int index) {
    final group = _subjectGroups[index];
    _nameController.text = group['name'];
    _selectedClass = group['class'];
    _selectedSection = group['section'];
    _descriptionController.text = group['description'];
    
    // Reset all subjects first
    _subjects.updateAll((key, value) => false);
    
    // Set selected subjects
    for (var subject in group['subjects']) {
      if (_subjects.containsKey(subject)) {
        _subjects[subject] = true;
      }
    }
    
    setState(() {});
    
    // Remove the old entry
    _subjectGroups.removeAt(index);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Group loaded for editing"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildSubjectCheckboxList() {
    // Sort subjects alphabetically
    final sortedSubjects = _subjects.keys.toList()..sort();
    
    return ListView.builder(
      controller: _subjectScrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sortedSubjects.length,
      itemBuilder: (context, index) {
        final subjectName = sortedSubjects[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: CheckboxListTile(
            dense: true,
            title: Text(
              subjectName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: _subjects[subjectName],
            onChanged: (val) {
              setState(() {
                _subjects[subjectName] = val!;
              });
            },
            contentPadding: const EdgeInsets.only(right: 8, left: 4),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _subjectScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Subject Group Management",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor:  const Color(0xFFB71C1C),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Create Subject Group Form
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create Subject Group",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create groups of subjects for different classes",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Name Field
                        const Text(
                          "Group Name *",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Enter group name (e.g., Science Group, Arts Group)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter group name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Class and Section Row
                        Row(
                          children: [
                            // Class Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Class *",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade400),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedClass,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      hint: const Text("Select Class"),
                                      items: _classList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedClass = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select class";
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Section Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Section *",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade400),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedSection,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      hint: const Text("Select Section"),
                                      items: _sectionList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSection = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select section";
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Subjects Selection
                        const Text(
                          "Select Subjects *",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Choose subjects to include in this group",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Scrollbar(
                            controller: _subjectScrollController,
                            thumbVisibility: true,
                            child: _buildSubjectCheckboxList(),
                          ),
                        ),
                        
                        const SizedBox(height: 25),

                        // Description
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter description (optional)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _addSubjectGroup,
                            child: const Text(
                              "Save Subject Group",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Subject Groups List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subject Groups",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_subjectGroups.length} Groups",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Groups List
              _subjectGroups.isEmpty
                  ? Card(
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.class_outlined,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Subject Groups Created",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Create your first subject group using the form above",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _subjectGroups.length,
                      itemBuilder: (context, index) {
                        final group = _subjectGroups[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        group["name"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue.shade700,
                                            size: 20,
                                          ),
                                          onPressed: () => _editGroup(index),
                                          tooltip: "Edit",
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color:  const Color(0xFFB71C1C),
                                            size: 20,
                                          ),
                                          onPressed: () => _deleteGroup(index),
                                          tooltip: "Delete",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.red.shade100,
                                        ),
                                      ),
                                      child: Text(
                                        "Class ${group["class"]}-${group["section"]}",
                                        style: TextStyle(
                                          color:  const Color(0xFFB71C1C),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.green.shade100,
                                        ),
                                      ),
                                      child: Text(
                                        "${group["subjects"].length} Subjects",
                                        style: TextStyle(
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Subjects:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (group["subjects"] as List<dynamic>)
                                      .map<Widget>((subject) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.blue.shade100,
                                              ),
                                            ),
                                            child: Text(
                                              subject.toString(),
                                              style: TextStyle(
                                                color: Colors.blue.shade800,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                if (group["description"] != null &&
                                    group["description"].toString().isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Description:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        group["description"].toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}