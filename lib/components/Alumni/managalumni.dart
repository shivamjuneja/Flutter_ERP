import 'package:flutter/material.dart';

class Student {
  final String admissionNo;
  final String name;
  final String className;
  final String section;
  final String gender;
  final String email;
  final String phone;
  final String passOutSession;
  final String status;

  Student({
    required this.admissionNo,
    required this.name,
    required this.className,
    required this.section,
    required this.gender,
    required this.email,
    required this.phone,
    required this.passOutSession,
    required this.status,
  });
}

class ManageAlumniScreen extends StatefulWidget {
  const ManageAlumniScreen({super.key});

  @override
  State<ManageAlumniScreen> createState() => _ManageAlumniScreenState();
}

class _ManageAlumniScreenState extends State<ManageAlumniScreen> {
  // Controllers
  final TextEditingController _searchController = TextEditingController();

  // Filter values
  String? _selectedPassOutSession;
  String? _selectedClass;
  String? _selectedSection;

  // Data
  List<Student> _filteredStudents = [];
  final List<Student> _allStudents = [
    Student(
      admissionNo: '2023001',
      name: 'Aarav Sharma',
      className: '10th',
      section: 'A',
      gender: 'Male',
      email: 'aarav.sharma@gmail.com',
      phone: '+91 98765 43210',
      passOutSession: '2025-26',
      status: 'Active',
    ),
    Student(
      admissionNo: '2023002',
      name: 'Priya Patel',
      className: '11th',
      section: 'B',
      gender: 'Female',
      email: 'priya.patel@gmail.com',
      phone: '+91 98765 43211',
      passOutSession: '2026-27',
      status: 'Active',
    ),
    Student(
      admissionNo: '2023003',
      name: 'Rohan Verma',
      className: '9th',
      section: 'C',
      gender: 'Male',
      email: 'rohan.verma@gmail.com',
      phone: '+91 98765 43212',
      passOutSession: '2027-28',
      status: 'Active',
    ),
  ];

  // Dropdown options
  final List<String> _passOutSessions = [
    '2025-26',
    '2026-27',
    '2027-28',
    '2028-29',
    '2029-30',
  ];

  final List<String> _classes = ['9th', '10th', '11th', '12th'];
  final List<String> _sections = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _allStudents;
    // Listen to search text changes
    _searchController.addListener(_searchStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchStudents);
    _searchController.dispose();
    super.dispose();
  }

  // Perform search and filtering
  void _searchStudents() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final matchesSearch = query.isEmpty ||
            student.admissionNo.toLowerCase().contains(query) ||
            student.name.toLowerCase().contains(query) ||
            student.className.toLowerCase().contains(query);

        final matchesSession = _selectedPassOutSession == null ||
            student.passOutSession == _selectedPassOutSession;

        final matchesClass = _selectedClass == null ||
            student.className == _selectedClass;

        final matchesSection = _selectedSection == null ||
            student.section == _selectedSection;

        return matchesSearch && matchesSession && matchesClass && matchesSection;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedPassOutSession = null;
      _selectedClass = null;
      _selectedSection = null;
      _searchController.clear();
      _filteredStudents = _allStudents;
    });
  }

  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Student Details', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Admission No', student.admissionNo),
              _buildDetailRow('Name', student.name),
              _buildDetailRow('Class', '${student.className} - ${student.section}'),
              _buildDetailRow('Gender', student.gender),
              _buildDetailRow('Email', student.email),
              _buildDetailRow('Phone', student.phone),
              _buildDetailRow('Pass Out Session', student.passOutSession),
              _buildDetailRow('Status', student.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(child: Text(value)),
        ],
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
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text('Select', style: TextStyle(color: Colors.grey[500])),
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              items: items
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (newValue) {
                onChanged(newValue);
                _searchStudents(); // Auto-filter when dropdown changes
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    // Calculate column widths based on content
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 56,
        dataRowHeight: 64,
        columns: const [
          DataColumn(
            label: Text('Admission No', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
          DataColumn(
            label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: false,
          ),
        ],
        rows: _filteredStudents.map((student) {
          return DataRow(cells: [
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 100),
                child: Text(student.admissionNo),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 150),
                child: Text(student.name),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 80),
                child: Text('${student.className} - ${student.section}'),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 80),
                child: Chip(
                  label: Text(student.gender),
                  backgroundColor: student.gender == 'Male' ? Colors.blue[50] : Colors.pink[50],
                  labelStyle: TextStyle(
                    color: student.gender == 'Male' ? Colors.blue[800] : Colors.pink[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 180),
                child: Text(student.email),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 120),
                child: Text(student.phone),
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(minWidth: 120),
                child: ElevatedButton(
                  onPressed: () => _showStudentDetails(student),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 90, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Students Found',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search term',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Manage Alumni', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filters Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter Students', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 8),
                    Text('Narrow down results using the options below', style: TextStyle(color: Colors.grey[600])),

                    const SizedBox(height: 20),

                    _buildDropdown(
                      label: 'Pass Out Session',
                      value: _selectedPassOutSession,
                      items: _passOutSessions,
                      onChanged: (val) => setState(() => _selectedPassOutSession = val),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Class',
                            value: _selectedClass,
                            items: _classes,
                            onChanged: (val) => setState(() => _selectedClass = val),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Section',
                            value: _selectedSection,
                            items: _sections,
                            onChanged: (val) => setState(() => _selectedSection = val),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _searchStudents,
                            icon: const Icon(Icons.search),
                            label: const Text('Apply Filters'),
                            style: ElevatedButton.styleFrom(
                              
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar
            Card(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, admission no, or class...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                          _searchController.clear();
                          _searchStudents();
                        })
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Results Table - FIXED: Removed the Row with the button and fixed overflow
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Records (${_filteredStudents.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Divider(height: 30),
                    _filteredStudents.isNotEmpty
                        ? _buildDataTable()
                        : _buildNoDataWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}