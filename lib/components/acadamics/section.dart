import 'package:flutter/material.dart';

class SectionScreen extends StatefulWidget {
  const SectionScreen({Key? key}) : super(key: key);

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  // Define the color
  final Color primaryColor = const Color(0xFFB71C1C);
  
  // Sample data with IDs
  List<Map<String, dynamic>> sections = [
    {'id': 1, 'name': 'A'},
    {'id': 2, 'name': 'B'},
    {'id': 3, 'name': 'C'},
    {'id': 4, 'name': 'C'},
  ];
  List<Map<String, dynamic>> filteredSections = [];
  
  // Controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController sectionNameController = TextEditingController();
  
  // Variables
  String searchQuery = '';
  bool isEditing = false;
  int? editingSectionId;

  @override
  void initState() {
    super.initState();
    filteredSections = List.from(sections);
    
    // Listen to search changes
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
        filterSections();
      });
    });
  }

  void filterSections() {
    if (searchQuery.isEmpty) {
      filteredSections = List.from(sections);
    } else {
      filteredSections = sections
          .where((section) =>
              section['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void addNewSection(String sectionName) {
    setState(() {
      sections.add({
        'id': sections.isNotEmpty ? sections.last['id'] + 1 : 1,
        'name': sectionName
      });
      filterSections();
    });
    sectionNameController.clear();
  }

  void editSection(int id, String newName) {
    setState(() {
      int index = sections.indexWhere((section) => section['id'] == id);
      if (index != -1) {
        sections[index]['name'] = newName;
      }
      filterSections();
    });
    sectionNameController.clear();
    isEditing = false;
    editingSectionId = null;
  }

  void deleteSection(int id) {
    setState(() {
      sections.removeWhere((section) => section['id'] == id);
      filterSections();
    });
  }

  void showDeleteConfirmationDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Section'),
          content: Text('Are you sure you want to delete "$name"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                deleteSection(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Section "$name" deleted'),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  void showAddEditSectionDialog({int? id, String? currentName}) {
    isEditing = id != null;
    editingSectionId = id;
    if (isEditing) {
      sectionNameController.text = currentName ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Section' : 'Add Section'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Section Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: sectionNameController,
                decoration: InputDecoration(
                  hintText: 'Enter section name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                sectionNameController.clear();
                isEditing = false;
                editingSectionId = null;
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (sectionNameController.text.trim().isNotEmpty) {
                  if (isEditing && editingSectionId != null) {
                    editSection(editingSectionId!, sectionNameController.text.trim());
                  } else {
                    addNewSection(sectionNameController.text.trim());
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 
                        'Section updated successfully' : 
                        'Section added successfully'),
                      backgroundColor: primaryColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a section name'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Section List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
          
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Text(
                  'Section',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  'Actions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Section List
          Expanded(
            child: ListView.builder(
              itemCount: filteredSections.length,
              itemBuilder: (context, index) {
                final section = filteredSections[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      section['name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: primaryColor,
                            size: 20,
                          ),
                          onPressed: () {
                            showAddEditSectionDialog(
                              id: section['id'],
                              currentName: section['name'],
                            );
                          },
                          tooltip: 'Edit',
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            showDeleteConfirmationDialog(
                              section['id'],
                              section['name'],
                            );
                          },
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Records Count
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Records: 1 to ${filteredSections.length} of ${filteredSections.length}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Add Section Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditSectionDialog(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    sectionNameController.dispose();
    super.dispose();
  }
}