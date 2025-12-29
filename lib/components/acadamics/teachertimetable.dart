import 'package:flutter/material.dart';

class TeacherTimeTable extends StatefulWidget {
  const TeacherTimeTable({Key? key}) : super(key: key);

  @override
  State<TeacherTimeTable> createState() => _TeacherTimeTableState();
}

class _TeacherTimeTableState extends State<TeacherTimeTable> {
  String? _selectedTeacher;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _teachers = [
    'John Smith',
    'Sarah Johnson',
    'Michael Brown',
    'Emily Davis',
    'Robert Wilson',
    'Lisa Anderson',
    'David Miller',
    'Jennifer Taylor',
  ];

  List<String> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _filteredTeachers = _teachers;
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTeachers = _teachers;
      } else {
        _filteredTeachers = _teachers
            .where((teacher) => teacher.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedTeacher = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teacher Time Table',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C), // Match your theme color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teachers label
            const Text(
              'Teachers *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search teachers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFB71C1C)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected teacher display
            if (_selectedTeacher != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB71C1C).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selected: $_selectedTeacher',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _clearSelection,
                      icon: const Icon(Icons.clear, color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Teachers list
            Expanded(
              child: _filteredTeachers.isEmpty
                  ? const Center(
                      child: Text(
                        'No teachers found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTeachers.length,
                      itemBuilder: (context, index) {
                        final teacher = _filteredTeachers[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFB71C1C),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              teacher,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: _selectedTeacher == teacher
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedTeacher = teacher;
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Action buttons
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedTeacher != null
                        ? () {
                            // Handle select action
                            _showTimeTable(_selectedTeacher!);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle search action
                      if (_searchController.text.isNotEmpty) {
                        _filterTeachers();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFFB71C1C)),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeTable(String teacherName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$teacherName\'s Time Table'),
        content: const Text('Time table details would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}