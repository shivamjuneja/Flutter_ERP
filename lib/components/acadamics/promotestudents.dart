import 'package:flutter/material.dart';

class PromoteStudentScreen extends StatefulWidget {
  const PromoteStudentScreen({Key? key}) : super(key: key);

  @override
  State<PromoteStudentScreen> createState() => _PromoteStudentScreenState();
}

class _PromoteStudentScreenState extends State<PromoteStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Dropdown values
  String? currentClass;
  String? currentSection;
  String? promoteSession;
  String? promoteClass;
  String? promoteSection;
  
  // To track if search has been performed
  bool _hasSearched = false;
  bool _isLoading = false;
  
  // Sample student data (replace with your API data)
  List<Map<String, dynamic>> _students = [];
  Map<int, bool> _selectedStudents = {};
  
  // Controllers for scrolling
  final ScrollController _scrollController = ScrollController();
  
  // Dropdown lists
  final List<String> classList = [
    "Nursery", "LKG", "UKG",
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"
  ];
  
  final List<String> sectionList = ["A", "B", "C", "D", "E", "F"];
  
  final List<String> promoteSessionList = [
    "2024-25",
    "2025-26",
    "2026-27",
    "2027-28",
    "2028-29",
    "2029-30"
  ];
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Promote Students",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 2,
      ),
      
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Form Section
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.shade50,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Current Class",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: "Class *",
                            value: currentClass,
                            items: classList,
                            onChanged: (val) {
                              setState(() {
                                currentClass = val;
                                _hasSearched = false;
                                _students.clear();
                                _selectedStudents.clear();
                              });
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        Expanded(
                          child: _buildDropdown(
                            label: "Section *",
                            value: currentSection,
                            items: sectionList,
                            onChanged: (val) {
                              setState(() {
                                currentSection = val;
                                _hasSearched = false;
                                _students.clear();
                                _selectedStudents.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    
                    const Text(
                      "Promote To Next Session",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildDropdown(
                      label: "Session *",
                      value: promoteSession,
                      items: promoteSessionList,
                      onChanged: (val) {
                        setState(() {
                          promoteSession = val;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: "Next Class *",
                            value: promoteClass,
                            items: classList,
                            onChanged: (val) {
                              setState(() {
                                promoteClass = val;
                              });
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        Expanded(
                          child: _buildDropdown(
                            label: "Next Section *",
                            value: promoteSection,
                            items: sectionList,
                            onChanged: (val) {
                              setState(() {
                                promoteSection = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.search, size: 20),
                        label: Text(
                          _isLoading ? "Searching..." : "Search Students",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _searchStudents,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Results Section
            _buildResultsSection(),
          ],
        ),
      ),
      
      // Promote Button (only shown when students are selected)
      floatingActionButton: _selectedStudents.isNotEmpty && 
                          _selectedStudents.values.any((isSelected) => isSelected)
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.school),
              label: const Text(
                "Promote Selected",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              onPressed: _promoteSelectedStudents,
            )
          : null,
    );
  }
  
  // Reusable Dropdown Builder
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
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              isDense: true,
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  "Select $label",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              ...items.map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              )).toList(),
            ],
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select $label";
              }
              return null;
            },
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
  
  // Build Results Section
  Widget _buildResultsSection() {
    if (!_hasSearched) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Search for students to promote",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Fill the form above and click Search",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      );
    }
    
    if (_students.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                "No students found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "No students found in $currentClass-$currentSection",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Students in $currentClass-$currentSection",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${_selectedStudents.values.where((isSelected) => isSelected).length} selected",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          // Select All Checkbox
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: _selectedStudents.isNotEmpty && 
                         _selectedStudents.values.every((isSelected) => isSelected),
                  onChanged: (value) {
                    setState(() {
                      for (var index in _selectedStudents.keys) {
                        _selectedStudents[index] = value ?? false;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Select All",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          
          // Students List
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        child: Text(
                          student['name'].toString().substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        student['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text("Roll No: ${student['rollNo']}"),
                      trailing: Checkbox(
                        value: _selectedStudents[index] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _selectedStudents[index] = value ?? false;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Search Students Function
  Future<void> _searchStudents() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Check if promote class is higher than current class
    final currentIndex = classList.indexOf(currentClass!);
    final promoteIndex = classList.indexOf(promoteClass!);
    
    if (promoteIndex <= currentIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Promote class must be higher than current class"),
          backgroundColor: Colors.orange.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Check if promoting to same class and section
    if (currentClass == promoteClass && currentSection == promoteSection) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Cannot promote to same class and section"),
          backgroundColor: Colors.orange.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Sample data - Replace with your API call
    final List<Map<String, dynamic>> sampleData = [
      {"id": 1, "name": "John Doe", "rollNo": "001"},
      {"id": 2, "name": "Jane Smith", "rollNo": "002"},
      {"id": 3, "name": "Robert Johnson", "rollNo": "003"},
      {"id": 4, "name": "Emily Davis", "rollNo": "004"},
      {"id": 5, "name": "Michael Wilson", "rollNo": "005"},
      {"id": 6, "name": "Sarah Brown", "rollNo": "006"},
      {"id": 7, "name": "David Miller", "rollNo": "007"},
      {"id": 8, "name": "Lisa Taylor", "rollNo": "008"},
    ];
    
    setState(() {
      _students = sampleData;
      _selectedStudents = {
        for (int i = 0; i < _students.length; i++) i: false
      };
      _hasSearched = true;
      _isLoading = false;
    });
  }
  
  // Promote Selected Students Function
  void _promoteSelectedStudents() {
    final selectedCount = _selectedStudents.values.where((isSelected) => isSelected).length;
    
    if (selectedCount == 0) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Promotion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to promote $selectedCount students?",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "From: $currentClass-$currentSection",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              "To: $promoteClass-$promoteSection",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              "Session: $promoteSession",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            onPressed: () {
              Navigator.pop(context);
              _performPromotion();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  // Perform Promotion Function
  Future<void> _performPromotion() async {
    final selectedStudents = _students
        .asMap()
        .entries
        .where((entry) => _selectedStudents[entry.key] == true)
        .map((entry) => entry.value)
        .toList();
    
    setState(() {
      _isLoading = true;
    });
    
    // TODO: Implement your API call here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Promoting ${selectedStudents.length} students..."),
        backgroundColor: Colors.blue.shade700,
      ),
    );
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Successfully promoted ${selectedStudents.length} students to $promoteClass-$promoteSection",
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Clear selections
    setState(() {
      _selectedStudents.updateAll((key, value) => false);
    });
    
    // Refresh the student list (in real app, you might want to fetch updated data)
    await _searchStudents();
  }
}