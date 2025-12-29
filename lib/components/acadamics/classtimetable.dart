import 'package:flutter/material.dart';

class ClassTimetableScreen extends StatefulWidget {
  const ClassTimetableScreen({super.key});

  @override
  State<ClassTimetableScreen> createState() => _ClassTimetableScreenState();
}

class _ClassTimetableScreenState extends State<ClassTimetableScreen> {
  String? _selectedClass;
  String? _selectedSection;
  bool _showTimetable = false;
  
  final List<String> _classes = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Nursery', 'LKG', 'UKG'];
  final List<String> _sections = ['Select', 'A', 'B', 'C', 'D'];

  final Map<String, List<String>> _timetable = {
    'Monday': ['Not Scheduled'],
    'Tuesday': ['Not Scheduled'],
    'Wednesday': ['Not Scheduled'],
    'Thursday': ['Not Scheduled'],
    'Friday': ['Not Scheduled'],
    'Saturday': ['Not Scheduled'],
    'Sunday': ['Not Scheduled'],
  };

  void _searchTimetable() {
    if (_selectedClass == null || _selectedSection == null || _selectedSection == 'Select') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Class and Section'),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
      return;
    }
    
    setState(() {
      _showTimetable = true;
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedClass = null;
      _selectedSection = null;
      _showTimetable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'CITY PUBLIC SCHOOL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_showTimetable)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetSelection,
              tooltip: 'Reset Selection',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Header Section
            // _buildHeaderSection(),
            // const SizedBox(height: 24),
            
            // Select Criteria Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Criteria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Class Dropdown
                    _buildDropdown(
                      label: 'Class*',
                      value: _selectedClass,
                      items: _classes,
                      onChanged: (value) {
                        setState(() {
                          _selectedClass = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Section Dropdown
                    _buildDropdown(
                      label: 'Section*',
                      value: _selectedSection,
                      items: _sections,
                      onChanged: (value) {
                        setState(() {
                          _selectedSection = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Search Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _searchTimetable,
                        icon: const Icon(Icons.search, size: 20),
                        label: const Text(
                          'Search Timetable',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Show Timetable only after search
            if (_showTimetable) ...[
              const SizedBox(height: 24),
              _buildTimetableSection(),
              const SizedBox(height: 20),
              
              // Add Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle add functionality
                    _showAddTimetableDialog(context);
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(
                    'Add +',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2C3E50)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: item == 'Select' ? Colors.grey[400] : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Timetable',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Chip(
                  label: Text(
                    'Class $_selectedClass - $_selectedSection',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF3498DB),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._timetable.entries.map((entry) {
              return _buildDayRow(entry.key, entry.value.first);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day, String schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: schedule == 'Not Scheduled' ? Colors.grey[300] : const Color(0xFF27AE60),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              schedule,
              style: TextStyle(
                color: schedule == 'Not Scheduled' ? Colors.grey[600] : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTimetableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add Timetable",
            style: TextStyle(color: Color(0xFF2C3E50)),
          ),
          content: const Text("Add timetable functionality will be implemented here."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Timetable added successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Color(0xFF2C3E50)),
              ),
            ),
          ],
        );
      },
    );
  }
}