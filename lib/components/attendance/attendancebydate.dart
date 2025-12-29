import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceByDateScreen extends StatefulWidget {
  const AttendanceByDateScreen({super.key});

  @override
  State<AttendanceByDateScreen> createState() => _AttendanceByDateScreenState();
}

class Student {
  final String admissionNo;
  final String rollNumber;
  final String name;
  String attendanceStatus;
  String? source;
  String? note;

  Student({
    required this.admissionNo,
    required this.rollNumber,
    required this.name,
    this.attendanceStatus = 'Present',
    this.source,
    this.note,
  });
}

class AttendanceStatus {
  static const String present = 'Present';
  static const String late = 'Late';
  static const String absent = 'Absent';
  static const String holiday = 'Holiday';
  static const String halfDay = 'Half Day';
  static const String na = 'N/A';

  static final List<String> allStatuses = [present, late, absent, holiday, halfDay, na];
}

class _AttendanceByDateScreenState extends State<AttendanceByDateScreen> {
  // Form controllers
  String? _selectedClass;
  String? _selectedSection;
  DateTime _selectedDate = DateTime.now();
  
  // Bulk attendance
  String? _selectedBulkAttendance;
  
  // Student list
  final List<Student> _students = [];
  
  // Filtered students (for search)
  List<Student> _filteredStudents = [];
  
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data
  final List<String> _classes = ['Select', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  final List<String> _sections = ['Select', 'A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> _attendanceOptions = AttendanceStatus.allStatuses;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
  }

  void _loadSampleStudents() {
    setState(() {
      _students.clear();
      _students.addAll([
        Student(
          admissionNo: 'ADM001',
          rollNumber: '1',
          name: 'John Doe',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM002',
          rollNumber: '2',
          name: 'Jane Smith',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM003',
          rollNumber: '3',
          name: 'Robert Johnson',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM004',
          rollNumber: '4',
          name: 'Emily Davis',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM005',
          rollNumber: '5',
          name: 'Michael Wilson',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM006',
          rollNumber: '6',
          name: 'Sarah Brown',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM007',
          rollNumber: '7',
          name: 'David Miller',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
        Student(
          admissionNo: 'ADM008',
          rollNumber: '8',
          name: 'Lisa Taylor',
          attendanceStatus: 'Present',
          source: 'Manual',
          note: '',
        ),
      ]);
      _filteredStudents = _students;
    });
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((student) {
          return student.name.toLowerCase().contains(query) ||
              student.admissionNo.toLowerCase().contains(query) ||
              student.rollNumber.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildSelectCriteriaSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Criteria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Class Dropdown - Vertical Layout
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Class*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedClass,
                      isExpanded: true,
                      hint: const Text('Select'),
                      items: _classes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedClass = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Section Dropdown - Vertical Layout
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Section*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSection,
                      isExpanded: true,
                      hint: const Text('Select'),
                      items: _sections.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSection = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date Picker - Vertical Layout
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Date*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedClass != null && _selectedClass != 'Select' &&
                      _selectedSection != null && _selectedSection != 'Select') {
                    _loadSampleStudents();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select both Class and Section'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkAttendanceSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set attendance for all students as',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            // Bulk Attendance Options
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _attendanceOptions.map((status) {
                final bool isSelected = _selectedBulkAttendance == status;
                return ChoiceChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedBulkAttendance = selected ? status : null;
                      if (selected) {
                        for (var student in _students) {
                          student.attendanceStatus = status;
                        }
                        _filterStudents();
                      }
                    });
                  },
                  selectedColor: const Color(0xFFB71C1C),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by name, admission no, or roll number...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Student List with DataTable - Fixed Height with Scrolling
            Container(
              height: 400, // Fixed height for the table container
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _filteredStudents.isEmpty
                  ? const Center(
                      child: Text(
                        'No students found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 16,
                          headingRowHeight: 50,
                          dataRowHeight: 70,
                          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columns: const [
                            DataColumn(
                              label: SizedBox(
                                width: 40,
                                child: Text(
                                  '#',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Admission No',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  'Roll Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 150,
                                child: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 150,
                                child: Text(
                                  'Attendance',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  'Source',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 180,
                                child: Text(
                                  'Note',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            _filteredStudents.length,
                            (index) {
                              final student = _filteredStudents[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 40,
                                      child: Text('${index + 1}'),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(student.admissionNo),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: Text(student.rollNumber),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 150,
                                      child: Text(student.name),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 150,
                                      child: DropdownButtonFormField<String>(
                                        value: student.attendanceStatus,
                                        isExpanded: true,
                                        isDense: true,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade400,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        items: _attendanceOptions.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: _getStatusColor(value),
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            student.attendanceStatus = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        student.source ?? 'Manual',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 180,
                                      child: TextFormField(
                                        initialValue: student.note ?? '',
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText: 'Add note...',
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade400,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          student.note = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
            
            // Records count and pagination
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Records: ${_filteredStudents.isEmpty ? 0 : 1} to ${_filteredStudents.length} of ${_filteredStudents.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        color: Colors.grey,
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB71C1C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        color: Colors.grey,
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Late':
        return Colors.orange;
      case 'Absent':
        return Colors.red;
      case 'Holiday':
        return Colors.purple;
      case 'Half Day':
        return Colors.blue;
      case 'N/A':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _saveAttendance() {
    int presentCount = _students.where((s) => s.attendanceStatus == 'Present').length;
    int absentCount = _students.where((s) => s.attendanceStatus == 'Absent').length;
    int lateCount = _students.where((s) => s.attendanceStatus == 'Late').length;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Attendance saved successfully! Present: $presentCount, Absent: $absentCount, Late: $lateCount',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Attendance By Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveAttendance,
            tooltip: 'Save Attendance',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedClass = null;
                _selectedSection = null;
                _selectedDate = DateTime.now();
                _selectedBulkAttendance = null;
                _students.clear();
                _filteredStudents.clear();
              });
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSelectCriteriaSection(),
              const SizedBox(height: 16),
              if (_students.isNotEmpty) ...[
                _buildBulkAttendanceSection(),
                const SizedBox(height: 16),
                _buildStudentListSection(),
              ],
              const SizedBox(height: 80), // Extra space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAttendance,
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 
 