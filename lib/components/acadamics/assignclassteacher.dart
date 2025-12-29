import 'package:flutter/material.dart';

class AssignClassTeacherScreen extends StatefulWidget {
  const AssignClassTeacherScreen({super.key});

  @override
  State<AssignClassTeacherScreen> createState() => _AssignClassTeacherScreenState();
}

class _AssignClassTeacherScreenState extends State<AssignClassTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedTeacher;
  
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
    '10'
  ];
  
  final List<String> _sections = [
    'Select',
    'A',
    'B',
    'C',
    'D'
  ];
  
  final List<String> _teachers = [
    'Select',
    'John Smith',
    'Sarah Johnson',
    'Michael Brown',
    'Emily Davis',
    'Robert Wilson',
    'Lisa Anderson'
  ];

  // RED COLOR SCHEME
  final Color primaryRed = const Color(0xFFB71C1C);
  final Color darkRed = const Color(0xFF8B0000);
  final Color lightRed = const Color(0xFFF44336);

  // Data for the class teacher list table
  final List<Map<String, String>> _classTeacherList = [];

  void _saveAssignment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Add to the list
      setState(() {
        _classTeacherList.add({
          'class': _selectedClass!,
          'section': _selectedSection!,
          'teacher': _selectedTeacher!,
        });
      });
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: primaryRed, size: 24),
                const SizedBox(width: 8),
                const Text('Success'),
              ],
            ),
            content: Text(
              'Class teacher assigned successfully for Class $_selectedClass - Section $_selectedSection',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear form
                  _formKey.currentState!.reset();
                  setState(() {
                    _selectedClass = null;
                    _selectedSection = null;
                    _selectedTeacher = null;
                  });
                },
                child: Text('OK', style: TextStyle(color: primaryRed)),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteAssignment(int index) {
    setState(() {
      _classTeacherList.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Assignment deleted successfully'),
        backgroundColor: primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Assign Class Teacher',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor:  primaryRed,
        elevation: 0,
        foregroundColor: Colors.white, // RED COLOR
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red[50]!, // RED COLOR
                      Colors.red[100]!, // RED COLOR
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryRed, // RED COLOR
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Class Teacher Assignment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Assign teachers to specific classes and sections',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Form Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Assign Class Teacher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the details to assign a class teacher',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Class Dropdown
                      _buildDropdownFormField(
                        label: 'Class *',
                        value: _selectedClass,
                        items: _classes,
                        onChanged: (value) {
                          setState(() {
                            _selectedClass = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select a class';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Section Dropdown
                      _buildDropdownFormField(
                        label: 'Section *',
                        value: _selectedSection,
                        items: _sections,
                        onChanged: (value) {
                          setState(() {
                            _selectedSection = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select a section';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Teacher Dropdown
                      _buildDropdownFormField(
                        label: 'Class Teacher *',
                        value: _selectedTeacher,
                        items: _teachers,
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacher = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select a teacher';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Save Button - RED COLOR
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _saveAssignment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed, // RED COLOR
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save',
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
            
            const SizedBox(height: 20),
            
            // Class Teacher List Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Search - FIXED OVERFLOW
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              color: primaryRed, // RED COLOR
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Class Teacher List',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Search Bar - Now on separate row
                        Container(
                          height: 40,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Table
                    _classTeacherList.isEmpty
                        ? _buildEmptyState()
                        : _buildClassTeacherTable(),
                        
                    const SizedBox(height: 8),
                    
                    // Records count
                    Text(
                      'Records: ${_classTeacherList.isEmpty ? 0 : 1} to ${_classTeacherList.length} of ${_classTeacherList.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: primaryRed, // RED COLOR
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Make sure to select the correct class, section and teacher before saving.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
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
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == 'Select' ? Colors.grey[500] : Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Select',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryRed, width: 2), // RED COLOR
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey[600],
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No data available in table',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add new record or search with different criteria.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClassTeacherTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 80,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
          dividerThickness: 1,
          dataRowMaxHeight: 52,
          columnSpacing: 20,
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Class',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Section',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Class Teacher',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Action',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          rows: _classTeacherList.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 80,
                    child: Text(
                      data['class']!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 80,
                    child: Text(
                      data['section']!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Text(
                      data['teacher']!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _deleteAssignment(index),
                        tooltip: 'Delete',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}