import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'createcertificate.dart';

class GenerateCertificateScreen extends StatefulWidget {
  const GenerateCertificateScreen({Key? key}) : super(key: key);

  @override
  State<GenerateCertificateScreen> createState() => _GenerateCertificateScreenState();
}

class _GenerateCertificateScreenState extends State<GenerateCertificateScreen> {
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedCertificate;
  DateTime _selectedDate = DateTime.now();
  
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = false;
  bool _showStudentList = false;
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _classes = [
    'Select',
    'Nursery',
    'LKG',
    'UKG',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  
  final List<String> _sections = [
    'Select',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];
  
  final List<String> _certificates = [
    'Select',
    'Birth Certificate',
    'Transfer Certificate',
    'Character Certificate',
    'Bonafide Certificate',
    'Fee Concession Certificate',
    'Sports Certificate',
    'Other'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Generate Certificate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Criteria Section
              _buildSelectCriteriaSection(),
              
              const SizedBox(height: 20),
              
              // Student List Section (Conditional)
              if (_showStudentList) ...[
                _buildStudentListSection(),
                const SizedBox(height: 20),
              ],
              
              // Action Buttons
              if (_showStudentList && _students.isNotEmpty) 
                _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectCriteriaSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            
            // Class Dropdown
            _buildDropdownField(
              label: 'Class*',
              value: _selectedClass,
              items: _classes,
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                  _showStudentList = false;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Section Dropdown
            _buildDropdownField(
              label: 'Section*',
              value: _selectedSection,
              items: _sections,
              onChanged: (value) {
                setState(() {
                  _selectedSection = value;
                  _showStudentList = false;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Certificate Type Dropdown
            _buildDropdownField(
              label: 'Certificate Type*',
              value: _selectedCertificate,
              items: _certificates,
              onChanged: (value) {
                setState(() {
                  _selectedCertificate = value;
                  _showStudentList = false;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Search Button
            Center(
              child: SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _searchStudents,
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search, size: 20),
                  label: Text(
                    _isLoading ? 'Searching...' : 'Search Students',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
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
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              iconEnabledColor: Colors.grey.shade600,
              hint: const Text('Select'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentListSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Responsive layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile layout - Stack title and search vertically
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student List',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSearchField(),
                    ],
                  );
                } else {
                  // Desktop layout - Row with title and search
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Student List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildSearchField(),
                      ),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Student Table
            if (_students.isEmpty)
              _buildEmptyState()
            else
              _buildStudentTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name or admission no...',
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No students found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select class and section to view students',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 72,
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => const Color(0xFF2C3E50),
            ),
            headingTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => Colors.white,
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            columnSpacing: 20,
            horizontalMargin: 16,
            columns: const [
              DataColumn(
                label: SizedBox(
                  width: 40,
                  child: Center(
                    child: Text('Select'),
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 120,
                  child: Text('Admission No'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 200,
                  child: Text('Student Name'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 80,
                  child: Text('Class'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 150,
                  child: Text('Father Name'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 120,
                  child: Text('Date Of Birth'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 100,
                  child: Text('Gender'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 100,
                  child: Text('Category'),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 140,
                  child: Text('Mobile Number'),
                ),
              ),
            ],
            rows: _students.map((student) {
              bool isSelected = student['isSelected'] ?? false;
              
              return DataRow(
                cells: [
                  DataCell(
                    Center(
                      child: Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              student['isSelected'] = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 120,
                      child: Text(
                        student['admissionNo'] ?? 'N/A',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            student['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (student['dob'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              '(${student['dob']})',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 80,
                      child: Text(student['class'] ?? ''),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        student['fatherName'] ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 120,
                      child: Text(student['dob'] ?? 'N/A'),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(
                            student['gender'] == 'Female' 
                                ? Icons.female
                                : Icons.male,
                            size: 16,
                            color: student['gender'] == 'Female'
                                ? Colors.pink
                                : Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(student['gender'] ?? ''),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(student['category']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          student['category'] ?? 'General',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 140,
                      child: Text(
                        student['mobile'] ?? 'N/A',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final selectedCount = _students.where((s) => s['isSelected'] == true).length;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - Column
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  '$selectedCount student${selectedCount == 1 ? '' : 's'} selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: selectedCount == 0 ? null : _generateCertificates,
                icon: const Icon(Icons.print, size: 20),
                label: const Text('Generate Selected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _selectAllStudents,
                icon: const Icon(Icons.check_box, size: 20),
                label: const Text('Select All'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2C3E50),
                  side: const BorderSide(color: Color(0xFF2C3E50)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Desktop layout - Row with scroll
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    '$selectedCount student${selectedCount == 1 ? '' : 's'} selected',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: selectedCount == 0 ? null : _generateCertificates,
                  icon: const Icon(Icons.print, size: 20),
                  label: const Text('Generate Selected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _selectAllStudents,
                  icon: const Icon(Icons.check_box, size: 20),
                  label: const Text('Select All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2C3E50),
                    side: const BorderSide(color: Color(0xFF2C3E50)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'sc':
        return const Color(0xFFE74C3C);
      case 'st':
        return const Color(0xFF3498DB);
      case 'obc':
        return const Color(0xFF2ECC71);
      case 'general':
        return const Color(0xFF95A5A6);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  void _searchStudents() async {
    if (_selectedClass == null || _selectedClass == 'Select') {
      _showError('Please select a class');
      return;
    }
    
    if (_selectedSection == null || _selectedSection == 'Select') {
      _showError('Please select a section');
      return;
    }
    
    if (_selectedCertificate == null || _selectedCertificate == 'Select') {
      _showError('Please select a certificate type');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Sample student data
    final sampleStudents = [
      {
        'admissionNo': '2024001',
        'name': 'Princy Patel',
        'class': '1(B)',
        'fatherName': 'Pradeep',
        'dob': '01/10/2015',
        'gender': 'Female',
        'category': 'OBC',
        'mobile': '9876543210',
        'isSelected': false,
      },
      {
        'admissionNo': '2024002',
        'name': 'Shubhi Pandey',
        'class': '1(B)',
        'fatherName': 'Vinay',
        'dob': '04/01/2016',
        'gender': 'Female',
        'category': 'General',
        'mobile': '8726581861',
        'isSelected': false,
      },
      {
        'admissionNo': '2024003',
        'name': 'Manvi Pandey',
        'class': '1(B)',
        'fatherName': 'Vinay',
        'dob': '02/01/2017',
        'gender': 'Female',
        'category': 'SC',
        'mobile': '',
        'isSelected': false,
      },
      {
        'admissionNo': '2024004',
        'name': 'Ram Patel',
        'class': '1(B)',
        'fatherName': 'Babulal',
        'dob': '01/01/2014',
        'gender': 'Male',
        'category': 'ST',
        'mobile': '9076833009',
        'isSelected': false,
      },
      {
        'admissionNo': '2024005',
        'name': 'Anubhav Maurya',
        'class': '1(B)',
        'fatherName': 'Jitendra',
        'dob': '01/01/2016',
        'gender': 'Male',
        'category': 'General',
        'mobile': '9696919956',
        'isSelected': false,
      },
      {
        'admissionNo': '2024006',
        'name': 'Sonam Sonkar',
        'class': '1(B)',
        'fatherName': 'Pintu',
        'dob': '01/01/2017',
        'gender': 'Female',
        'category': 'OBC',
        'mobile': '6230217513',
        'isSelected': false,
      },
      {
        'admissionNo': '2024007',
        'name': 'Suhani',
        'class': '1(B)',
        'fatherName': 'Anil Kumar',
        'dob': '01/01/2017',
        'gender': 'Female',
        'category': 'General',
        'mobile': '9517663424',
        'isSelected': false,
      },
      {
        'admissionNo': '2024008',
        'name': 'Shreya',
        'class': '1(B)',
        'fatherName': 'Suneel Kumar',
        'dob': '10/08/2017',
        'gender': 'Female',
        'category': 'General',
        'mobile': '7518134780',
        'isSelected': false,
      },
    ];
    
    setState(() {
      _students = sampleStudents;
      _showStudentList = true;
      _isLoading = false;
    });
  }

  void _selectAllStudents() {
    setState(() {
      bool allSelected = _students.every((s) => s['isSelected'] == true);
      
      for (var student in _students) {
        student['isSelected'] = !allSelected;
      }
    });
  }

  void _generateCertificates() {
    final selectedStudents = _students.where((s) => s['isSelected'] == true).toList();
    
    if (selectedStudents.isEmpty) {
      _showError('Please select at least one student');
      return;
    }
    
    // Navigate to CreateCertificate screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateCertificateFinalScreen(
          selectedStudents: selectedStudents,
          certificateType: _selectedCertificate ?? 'Certificate',
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}