import 'package:flutter/material.dart';

// Class data model
class ClassData {
  final String className;
  final List<String> sections;
  final String? subject;
  final String? classType;
  final int? capacity;
  final String? room;
  final String? startTime;
  final String? endTime;
  final DateTime? startDate;
  final int days;

  ClassData({
    required this.className,
    required this.sections,
    this.subject,
    this.classType,
    this.capacity,
    this.room,
    this.startTime,
    this.endTime,
    this.startDate,
    this.days = 0,
  });
}

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({Key? key}) : super(key: key);

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final List<String> _availableSections = ["A", "B", "C", "D", "E"];
  final List<String> _selectedSections = [];
  String? _selectedClassType;
  final List<String> _classTypes = [
    "Regular",
    "Honors",
    "Advanced",
    "Remedial",
    "Elective"
  ];
  String? _selectedSubject;
  final List<String> _subjects = [
    "Mathematics",
    "Science",
    "English",
    "History",
    "Physics",
    "Chemistry",
    "Biology",
    "Computer Science",
    "Art",
    "Music"
  ];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDate;
  int _selectedDays = 0;
  final List<bool> _weekDays = List.generate(7, (index) => false);
  final List<String> _weekDayLabels = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  // For class list table
  final List<ClassData> _classList = [];
  final TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Colors - Professional color scheme
  final Color _primaryColor = const Color(0xFFB71C1C);
  final Color _secondaryColor = const Color(0xFFD32F2F);
  final Color _accentColor = const Color(0xFFFF9800);
  final Color _successColor = const Color(0xFF388E3C);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF333333);
  final Color _hintColor = const Color(0xFF757575);
  final Color _tableHeaderColor = const Color(0xFFE0E0E0);
  final Color _tableRowColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    // Add some dummy data for demonstration
    _classList.addAll([
      ClassData(className: "10", sections: ["A", "B", "C"]),
      ClassData(className: "9", sections: ["A", "B"]),
      ClassData(className: "UKG", sections: ["A", "B", "C"]),
      ClassData(className: "LKG", sections: ["A", "B", "C"]),
      ClassData(className: "Nursery", sections: ["A", "B", "C"]),
      ClassData(className: "8", sections: ["A", "B"]),
      ClassData(className: "7", sections: ["A", "B"]),
      ClassData(className: "6", sections: ["A", "B"]),
      ClassData(className: "5", sections: ["A", "B"]),
    ]);
  }

  @override
  void dispose() {
    _classController.dispose();
    _capacityController.dispose();
    _roomController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: _primaryColor,
            colorScheme: ColorScheme.light(primary: _primaryColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: _primaryColor,
            colorScheme: ColorScheme.light(primary: _primaryColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addCustomSection() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController customSectionController =
            TextEditingController();
        return AlertDialog(
          title: Text(
            "Add Custom Section",
            style: TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextFormField(
            controller: customSectionController,
            decoration: InputDecoration(
              labelText: "Section Name",
              labelStyle: TextStyle(color: _primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryColor, width: 2),
              ),
              prefixIcon: Icon(Icons.label, color: _primaryColor),
            ),
            autofocus: true,
            maxLength: 2,
            textCapitalization: TextCapitalization.characters,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: _hintColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (customSectionController.text.isNotEmpty) {
                  final newSection =
                      customSectionController.text.toUpperCase();
                  if (!_availableSections.contains(newSection)) {
                    setState(() {
                      _availableSections.add(newSection);
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedSections.clear();
      _selectedClassType = null;
      _selectedSubject = null;
      _startTime = null;
      _endTime = null;
      _selectedDate = null;
      _selectedDays = 0;
      for (int i = 0; i < _weekDays.length; i++) {
        _weekDays[i] = false;
      }
      _capacityController.clear();
      _roomController.clear();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validate sections
      if (_selectedSections.isEmpty) {
        _showSnackBar("Please select at least 1 section", _primaryColor);
        return;
      }

      // Validate time
      if (_startTime != null && _endTime != null) {
        final startHour = _startTime!.hour * 60 + _startTime!.minute;
        final endHour = _endTime!.hour * 60 + _endTime!.minute;
        if (endHour <= startHour) {
          _showSnackBar("End time must be after start time", _accentColor);
          return;
        }
      }

      // Validate week days
      if (_selectedDays == 0) {
        _showSnackBar("Please select at least 1 day", _primaryColor);
        return;
      }
 
      // Create new class data
      final newClass = ClassData(
        className: _classController.text.trim(),
        subject: _selectedSubject,
        sections: List.from(_selectedSections),
        classType: _selectedClassType,
        capacity: _capacityController.text.isNotEmpty
            ? int.parse(_capacityController.text)
            : null,
        room: _roomController.text.isNotEmpty ? _roomController.text : null,
        startTime: _startTime?.format(context),
        endTime: _endTime?.format(context),
        startDate: _selectedDate,
        days: _selectedDays,
      );

      // Add to class list
      setState(() {
        _classList.add(newClass);
      });

      // Show success message
      _showSnackBar("Class added successfully!", _successColor);

      // Clear form
      _clearForm();
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteClass(int index) {
    setState(() {
      _classList.removeAt(index);
    });
    _showSnackBar("Class deleted successfully!", _primaryColor);
  }

  List<ClassData> get _filteredClassList {
    if (_searchController.text.isEmpty) {
      return _classList;
    }
    return _classList
        .where((classData) => classData.className
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
  }

  Widget _buildClassListTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Class List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  icon: Icon(Icons.refresh, color: _primaryColor),
                  tooltip: "Refresh",
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: _primaryColor),
                  const SizedBox(width: 12),
                  Flexible(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: _hintColor),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: _primaryColor, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 40,
                ),
                child: DataTable(
                  columnSpacing: 20,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.all(_tableHeaderColor),
                  headingRowHeight: 50,
                  dataRowHeight: 50,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Class',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sections',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  rows: _buildTableRows(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildTableRows() {
    final List<DataRow> rows = [];
    final filteredList = _filteredClassList;

    for (int i = 0; i < filteredList.length; i++) {
      final classData = filteredList[i];
      for (int j = 0; j < classData.sections.length; j++) {
        rows.add(
          DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return _primaryColor.withOpacity(0.08);
                }
                return j % 2 == 0 ? _tableRowColor : Colors.white;
              },
            ),
            cells: [
              DataCell(
                j == 0
                    ? Text(
                        classData.className,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              DataCell(
                Text(
                  classData.sections[j],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _successColor,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: _primaryColor,
                        size: 20,
                      ),
                      onPressed: () => _deleteClass(i),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: "Delete",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    if (rows.isEmpty) {
      return [
        DataRow(cells: [
          DataCell(
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: const Center(
                child: Text(
                  "No classes found",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ),
          const DataCell(SizedBox.shrink()),
          const DataCell(SizedBox.shrink()),
        ])
      ];
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          "Add New Class",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Class Form (First Section)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: _cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Icon
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.school,
                                color: _primaryColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Create New Class",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Fill in the class details below",
                              style: TextStyle(
                                fontSize: 14,
                                color: _hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Class Name Field
                      _buildSectionTitle("Class Information"),
                      const SizedBox(height: 16),

                      _buildFormField(
                        label: "Class Name *",
                        hint: "e.g., Mathematics 101",
                        icon: Icons.class_,
                        controller: _classController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Class name is required";
                          }
                          if (value.length < 3) {
                            return "Class name must be at least 3 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Subject Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subject",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedSubject,
                            decoration: InputDecoration(
                              hintText: "Select subject",
                              hintStyle: TextStyle(color: _hintColor),
                              prefixIcon:
                                  Icon(Icons.subject, color: _primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: _primaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            dropdownColor: Colors.white,
                            icon:
                                Icon(Icons.arrow_drop_down, color: _primaryColor),
                            style: TextStyle(color: _textColor),
                            items: _subjects.map((subject) {
                              return DropdownMenuItem(
                                value: subject,
                                child: Text(subject),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubject = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Class Type Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Class Type",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedClassType,
                            decoration: InputDecoration(
                              hintText: "Select class type",
                              hintStyle: TextStyle(color: _hintColor),
                              prefixIcon:
                                  Icon(Icons.category, color: _primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: _primaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            dropdownColor: Colors.white,
                            icon:
                                Icon(Icons.arrow_drop_down, color: _primaryColor),
                            style: TextStyle(color: _textColor),
                            items: _classTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedClassType = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Room and Capacity Row
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // Wide screen: use row layout
                            return Row(
                              children: [
                                Flexible(
                                  child: _buildFormField(
                                    label: "Room Number",
                                    hint: "e.g., 101",
                                    icon: Icons.meeting_room,
                                    controller: _roomController,
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: _buildFormField(
                                    label: "Student Capacity",
                                    hint: "e.g., 30",
                                    icon: Icons.people,
                                    controller: _capacityController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        final capacity = int.tryParse(value);
                                        if (capacity == null || capacity <= 0) {
                                          return "Enter valid number";
                                        }
                                        if (capacity > 100) {
                                          return "Max 100 students";
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Narrow screen: use column layout
                            return Column(
                              children: [
                                _buildFormField(
                                  label: "Room Number",
                                  hint: "e.g., 101",
                                  icon: Icons.meeting_room,
                                  controller: _roomController,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 20),
                                _buildFormField(
                                  label: "Student Capacity",
                                  hint: "e.g., 30",
                                  icon: Icons.people,
                                  controller: _capacityController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final capacity = int.tryParse(value);
                                      if (capacity == null || capacity <= 0) {
                                        return "Enter valid number";
                                      }
                                      if (capacity > 100) {
                                        return "Max 100 students";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 32),

                      // Time and Date Section
                      _buildSectionTitle("Schedule"),
                      const SizedBox(height: 16),

                      // Time Row
                      Row(
                        children: [
                          Flexible(
                            child: _buildTimeField(
                              "Start Time",
                              _startTime?.format(context) ?? "Select",
                              () => _selectTime(context, true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: _buildTimeField(
                              "End Time",
                              _endTime?.format(context) ?? "Select",
                              () => _selectTime(context, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Date Field
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: _primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Start Date",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _hintColor,
                                      ),
                                    ),
                                    Text(
                                      _selectedDate != null
                                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                          : "Select start date",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _selectedDate != null
                                            ? _textColor
                                            : _hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: _primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Week Days Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Days of Week *",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _weekDays[index] = !_weekDays[index];
                                        _selectedDays = _weekDays
                                            .where((day) => day)
                                            .length;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _weekDays[index]
                                            ? _primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _weekDays[index]
                                              ? _primaryColor
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _weekDayLabels[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _weekDays[index]
                                                ? Colors.white
                                                : _textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Selected: $_selectedDays days",
                            style: TextStyle(
                              fontSize: 12,
                              color: _hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sections Section
                      _buildSectionTitle("Sections"),
                      const SizedBox(height: 12),
                      Text(
                        "Select at least one section *",
                        style: TextStyle(
                          fontSize: 12,
                          color: _hintColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sections Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _availableSections.length,
                        itemBuilder: (context, index) {
                          final section = _availableSections[index];
                          final isSelected = _selectedSections.contains(section);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSections.remove(section);
                                } else {
                                  _selectedSections.add(section);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? _primaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? _primaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  section,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : _primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Add Custom Section Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _addCustomSection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor.withOpacity(0.1),
                              foregroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add Custom Section"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Selected Sections Display
                      if (_selectedSections.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Selected Sections (${_selectedSections.length})",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedSections.map((section) {
                                return Chip(
                                  label: Text(
                                    section,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: _primaryColor,
                                  deleteIcon: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedSections.remove(section);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 400) {
                            // Wide enough for row layout
                            return Row(
                              children: [
                                Flexible(
                                  child: OutlinedButton(
                                    onPressed: _clearForm,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side:
                                          BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: const Text(
                                      "Clear All",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      "Save Class",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Too narrow, use column
                            return Column(
                              children: [
                                OutlinedButton(
                                  onPressed: _clearForm,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  child: const Text(
                                    "Clear All",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    "Save Class",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Info Card
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryColor.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: _primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Each selected section will be created as a separate class entity. "
                      "You'll be able to manage attendance, grades, and students for each section independently.",
                      style: TextStyle(
                        color: _hintColor,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Footer Note
            Text(
              "* Required fields",
              style: TextStyle(
                color: _hintColor,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),

            // Class List Table (Second Section)
            if (_classList.isNotEmpty) ...[
              _buildClassListTable(),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: _primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: _hintColor),
            prefixIcon: Icon(icon, color: _primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: _primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value != "Select" ? _textColor : _hintColor,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: _primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}