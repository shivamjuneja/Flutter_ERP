import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // Form variables
  String? _selectedEventFor = 'All Alumni';
  String? _selectedClass;
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _templateIdController = TextEditingController();
  
  DateTime? _fromDate;
  DateTime? _toDate;
  
  bool _emailNotification = false;
  bool _smsNotification = false;
  
  // Dropdown options
  final List<String> _eventForOptions = ['All Alumni', 'Class'];
  final List<String> _classOptions = [
    'Class 2024 - Section A',
    'Class 2024 - Section B',
    'Class 2023 - Section A',
    'Class 2023 - Section B',
    'Class 2022 - Section A',
    'Class 2022 - Section B',
    'Class 2021 - Section A',
    'Class 2021 - Section B',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Event',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event For Section
                    _buildSectionTitle('Event For'),
                    const SizedBox(height: 12),
                    _buildEventForSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Event Title
                    _buildSectionTitle('Event Title'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      hintText: 'Enter event title',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Event From Date'),
                              const SizedBox(height: 12),
                              _buildDatePicker(
                                date: _fromDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _fromDate = date;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Event To Date'),
                              const SizedBox(height: 12),
                              _buildDatePicker(
                                date: _toDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _toDate = date;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Photo Upload Section
                    _buildSectionTitle('Photo (100px X 100px)'),
                    const SizedBox(height: 12),
                    _buildPhotoUploadSection(),
                    
                    const SizedBox(height: 32),
                    _buildDivider(),
                    const SizedBox(height: 32),
                    
                    // Note Section
                    _buildSectionTitle('Note', fontSize: 22),
                    const SizedBox(height: 16),
                    _buildNoteSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Event Notification Section
                    _buildSectionTitle('Event Notification Message', fontSize: 22),
                    const SizedBox(height: 16),
                    _buildNotificationSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double fontSize = 16}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildEventForSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event For Dropdown
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedEventFor,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                items: _eventForOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEventFor = newValue;
                    if (newValue != 'Class') {
                      _selectedClass = null;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        
        // Class Dropdown (only visible when Event For is "Class")
        if (_selectedEventFor == 'Class') ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClass,
                  isExpanded: true,
                  hint: const Text(
                    'Select Class',
                    style: TextStyle(color: Colors.grey),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  items: _classOptions.map((String value) {
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
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({String? hintText, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: hintText == 'Enter event title' ? _eventTitleController : null,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required DateTime? date,
    required Function(DateTime?) onDateSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null ? _formatDate(date!) : 'Select date',
                style: TextStyle(
                  color: date != null ? Colors.black87 : Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Upload area
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 32,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag and\ndrop a file\nhere or click',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          // Refresh icon
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.refresh,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildNoteSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Add notes about the event...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkboxes
        Row(
          children: [
            _buildCheckbox(
              value: _emailNotification,
              label: 'Email',
              onChanged: (value) {
                setState(() {
                  _emailNotification = value ?? false;
                });
              },
            ),
            const SizedBox(width: 32),
            _buildCheckbox(
              value: _smsNotification,
              label: 'SMS',
              onChanged: (value) {
                setState(() {
                  _smsNotification = value ?? false;
                });
              },
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Template ID Field
        _buildSectionTitle('Template ID'),
        const SizedBox(height: 8),
        Text(
          '(This field is required Only For Indian SMS Gateway)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _templateIdController,
            decoration: const InputDecoration(
              hintText: 'Enter template ID',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required String label,
    required Function(bool?) onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: value ? const Color(0xFFB71C1C) : Colors.grey[400]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            color: value ? const Color(0xFFB71C1C) : Colors.transparent,
          ),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Save and Close action
            _saveEvent();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB71C1C),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'SAVE AND CLOSE',
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _saveEvent() {
    // Validation
    if (_eventTitleController.text.isEmpty) {
      _showSnackBar('Please enter event title');
      return;
    }
    
    if (_fromDate == null) {
      _showSnackBar('Please select from date');
      return;
    }
    
    if (_toDate == null) {
      _showSnackBar('Please select to date');
      return;
    }
    
    if (_fromDate!.isAfter(_toDate!)) {
      _showSnackBar('From date cannot be after to date');
      return;
    }
    
    if (_smsNotification && _templateIdController.text.isEmpty) {
      _showSnackBar('Template ID is required for SMS notifications');
      return;
    }
    
    // Save logic here (you can add your API call or database logic)
    final eventData = {
      'eventFor': _selectedEventFor,
      'class': _selectedClass,
      'eventTitle': _eventTitleController.text,
      'fromDate': _fromDate,
      'toDate': _toDate,
      'note': _noteController.text,
      'emailNotification': _emailNotification,
      'smsNotification': _smsNotification,
      'templateId': _templateIdController.text,
    };
    
    print('Event data: $eventData');
    
    // Show success message
    _showSuccessDialog();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 12),
            Text('Success'),
          ],
        ),
        content: const Text('Event has been created successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eventTitleController.dispose();
    _noteController.dispose();
    _templateIdController.dispose();
    super.dispose();
  }
}