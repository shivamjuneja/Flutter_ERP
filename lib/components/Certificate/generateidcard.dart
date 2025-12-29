import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenerateIDCardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedStudents;

  const GenerateIDCardScreen({
    Key? key,
    required this.selectedStudents,
  }) : super(key: key);

  @override
  State<GenerateIDCardScreen> createState() => _GenerateIDCardScreenState();
}

class _GenerateIDCardScreenState extends State<GenerateIDCardScreen> {
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _validUntilController = TextEditingController();
  final TextEditingController _authorizedByController = TextEditingController();
  
  DateTime _issueDate = DateTime.now();
  DateTime? _validUntilDate;
  
  bool _includePhoto = true;
  bool _includeBarcode = true;
  bool _includeSchoolLogo = true;
  bool _includeBloodGroup = false;
  bool _includeAddress = true;
  bool _includeQRCode = false;
  
  String _selectedCardSize = 'Standard (85.6x54mm)';
  String _selectedOrientation = 'Portrait';
  String _selectedTemplate = 'Template 1';
  String _selectedPrintType = 'Single Side';
  String _selectedIDCardTemplate = 'Modern';
  
  final List<String> _cardSizes = [
    'Standard (85.6x54mm)',
    'Large (90x60mm)',
    'Custom Size'
  ];
  
  final List<String> _orientations = ['Portrait', 'Landscape'];
  final List<String> _templates = ['Template 1', 'Template 2', 'Template 3', 'Modern', 'Classic'];
  final List<String> _printTypes = ['Single Side', 'Double Side'];
  final List<String> _idCardTemplates = ['Modern', 'Classic', 'Professional', 'Colorful', 'Minimal'];
  
  Color _primaryColor = const Color(0xFF1A237E);
  Color _secondaryColor = const Color(0xFF283593);

  // Sample data to use when no students are selected
  final List<Map<String, dynamic>> _sampleStudents = [
    {
      'name': 'Vaibhav (Krish)',
      'class': '2(B)',
      'fatherName': 'Vinod Kumar',
      'admissionNo': '2025-001',
      'dob': '01/01/2014',
      'address': 'Lansia Manipur',
      'phone': '010/12014',
      'bloodGroup': 'A+',
    },
    {
      'name': 'Lavish Maurya',
      'class': '2(B)',
      'fatherName': 'Santal',
      'admissionNo': '2025-002',
      'dob': '01/01/2015',
      'address': 'Manipur',
      'phone': '9468752963',
      'bloodGroup': 'B+',
    },
    {
      'name': 'Aryan Maurya',
      'class': '2(B)',
      'fatherName': 'Dheer Singh',
      'admissionNo': '2025-003',
      'dob': '01/01/2017',
      'address': 'Manipur',
      'phone': '8073405967',
      'bloodGroup': 'O+',
    },
    {
      'name': 'Abhishek Patel',
      'class': '2(B)',
      'fatherName': 'Rajesh Kumar',
      'admissionNo': '2025-004',
      'dob': '12/03/2016',
      'address': 'Manipur',
      'phone': '8382030119',
      'bloodGroup': 'AB+',
    },
    {
      'name': 'Shubham Patel',
      'class': '2(B)',
      'fatherName': 'Arvind Kumar',
      'admissionNo': '2025-005',
      'dob': '01/01/2017',
      'address': 'Manipur',
      'phone': '9118865001',
      'bloodGroup': 'B-',
    },
  ];

  @override
  void initState() {
    super.initState();
    _issueDateController.text = DateFormat('dd/MM/yyyy').format(_issueDate);
    _authorizedByController.text = 'Principal';
    
    // Set default valid until date (1 year from now)
    _validUntilDate = DateTime.now().add(const Duration(days: 365));
    _validUntilController.text = DateFormat('dd/MM/yyyy').format(_validUntilDate!);
  }

  @override
  void dispose() {
    _issueDateController.dispose();
    _validUntilController.dispose();
    _authorizedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.selectedStudents if provided, otherwise use sample data
    final students = widget.selectedStudents.isNotEmpty 
        ? widget.selectedStudents 
        : _sampleStudents;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Generate ID Card', // Changed from 'Generate ID Cards' to 'Generate ID Card'
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadAllIDCards,
            tooltip: 'Download All',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printAllIDCards,
            tooltip: 'Print All',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Settings
          Container(
            width: 320,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingsHeader(),
                    const SizedBox(height: 16),
                    
                    // ID Card Details
                    _buildSettingsCard(
                      title: 'ID Card Details',
                      children: [
                        _buildDateField(
                          label: 'Issue Date*',
                          controller: _issueDateController,
                          onTap: () => _selectDate(context, isIssueDate: true),
                        ),
                        const SizedBox(height: 12),
                        _buildDateField(
                          label: 'Valid Until*',
                          controller: _validUntilController,
                          onTap: () => _selectDate(context, isIssueDate: false),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Authorized By*',
                          controller: _authorizedByController,
                          icon: Icons.verified_user,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Design Settings
                    _buildSettingsCard(
                      title: 'Design Settings',
                      children: [
                        // Added ID Card Template field at the top
                        _buildDropdownSetting(
                          label: 'ID Card Template *',
                          value: _selectedIDCardTemplate,
                          items: _idCardTemplates,
                          onChanged: (value) => setState(() => _selectedIDCardTemplate = value!),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildCheckboxOption(
                          label: 'Include Student Photo',
                          value: _includePhoto,
                          onChanged: (value) => setState(() => _includePhoto = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include Barcode',
                          value: _includeBarcode,
                          onChanged: (value) => setState(() => _includeBarcode = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include School Logo',
                          value: _includeSchoolLogo,
                          onChanged: (value) => setState(() => _includeSchoolLogo = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include Blood Group',
                          value: _includeBloodGroup,
                          onChanged: (value) => setState(() => _includeBloodGroup = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include Address',
                          value: _includeAddress,
                          onChanged: (value) => setState(() => _includeAddress = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include QR Code',
                          value: _includeQRCode,
                          onChanged: (value) => setState(() => _includeQRCode = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          label: 'Card Size',
                          value: _selectedCardSize,
                          items: _cardSizes,
                          onChanged: (value) => setState(() => _selectedCardSize = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          label: 'Orientation',
                          value: _selectedOrientation,
                          items: _orientations,
                          onChanged: (value) => setState(() => _selectedOrientation = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          label: 'Template',
                          value: _selectedTemplate,
                          items: _templates,
                          onChanged: (value) => setState(() => _selectedTemplate = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          label: 'Print Type',
                          value: _selectedPrintType,
                          items: _printTypes,
                          onChanged: (value) => setState(() => _selectedPrintType = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildColorPicker(
                          label: 'Primary Color',
                          color: _primaryColor,
                          onColorChanged: (color) => setState(() => _primaryColor = color),
                        ),
                        const SizedBox(height: 8),
                        _buildColorPicker(
                          label: 'Secondary Color',
                          color: _secondaryColor,
                          onColorChanged: (color) => setState(() => _secondaryColor = color),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Selected Students
                    _buildSettingsCard(
                      title: 'Selected Students (${students.length})',
                      children: [
                        SizedBox(
                          height: 150,
                          child: students.isEmpty
                              ? Center(
                                  child: Text(
                                    'No students selected',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: students.length,
                                  itemBuilder: (context, index) {
                                    final student = students[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: _primaryColor.withOpacity(0.1),
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: _primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  student['name'] ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Class: ${student['class'] ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color: _primaryColor,
                                            ),
                                            onPressed: () => _previewIDCard(student),
                                            tooltip: 'Preview',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: 8),
                    
                    // Info Text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ID cards will be generated in high resolution (300 DPI) for printing',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Right Panel - Preview
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  // Preview Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ID Card Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Scale: 100%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.zoom_out),
                              onPressed: _zoomOut,
                              tooltip: 'Zoom Out',
                            ),
                            IconButton(
                              icon: const Icon(Icons.zoom_in),
                              onPressed: _zoomIn,
                              tooltip: 'Zoom In',
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _resetPreview,
                              tooltip: 'Reset',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // ID Card Preview
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Template indicator
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Template: $_selectedIDCardTemplate',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Front Side
                            _buildIDCardFront(students.isNotEmpty ? students.first : _sampleStudents.first),
                            const SizedBox(height: 32),
                            
                            // Back Side (if double sided)
                            if (_selectedPrintType == 'Double Side')
                              Column(
                                children: [
                                  const Text(
                                    'Back Side',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildIDCardBack(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ID Card Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize ID card design and details',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
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
        InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text,
                    style: const TextStyle(fontSize: 14),
                  ),
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
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
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: _primaryColor,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String label,
    required String value,
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
        const SizedBox(height: 6),
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

  Widget _buildColorPicker({
    required String label,
    required Color color,
    required Function(Color) onColorChanged,
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
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildColorOption(const Color(0xFF1A237E), onColorChanged),
                  _buildColorOption(const Color(0xFF283593), onColorChanged),
                  _buildColorOption(const Color(0xFF1565C0), onColorChanged),
                  _buildColorOption(const Color(0xFF2E7D32), onColorChanged),
                  _buildColorOption(const Color(0xFF6A1B9A), onColorChanged),
                  _buildColorOption(const Color(0xFFC62828), onColorChanged),
                  _buildColorOption(const Color(0xFFEF6C00), onColorChanged),
                  _buildColorOption(const Color(0xFF00695C), onColorChanged),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color, Function(Color) onColorChanged) {
    return InkWell(
      onTap: () => onColorChanged(color),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final students = widget.selectedStudents.isNotEmpty 
        ? widget.selectedStudents 
        : _sampleStudents;
    
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _generateSingleIDCard(students),
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Current'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _generateAllIDCards(students),
            icon: const Icon(Icons.batch_prediction, size: 20),
            label: const Text('Generate All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIDCardFront(Map<String, dynamic> student) {
    // Apply template-specific styles
    Color headerColor = _primaryColor;
    Color textColor = const Color(0xFF1A237E);
    TextStyle nameStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: textColor,
    );
    
    // Adjust styles based on selected template
    switch (_selectedIDCardTemplate) {
      case 'Classic':
        headerColor = const Color(0xFF795548);
        textColor = const Color(0xFF5D4037);
        nameStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'Times New Roman',
        );
        break;
      case 'Professional':
        headerColor = const Color(0xFF37474F);
        textColor = const Color(0xFF263238);
        nameStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        );
        break;
      case 'Colorful':
        headerColor = Colors.purple;
        textColor = Colors.purple.shade800;
        nameStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        );
        break;
      case 'Minimal':
        headerColor = Colors.grey.shade800;
        textColor = Colors.grey.shade800;
        nameStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
        break;
    }

    return Container(
      width: 340,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Design based on template
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getBackgroundGradient(),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  'CITY PUBLIC SCHOOL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Photo
                if (_includePhoto)
                  Container(
                    width: 100,
                    height: 120,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'STUDENT PHOTO',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Student Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // School Logo
                      if (_includeSchoolLogo)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: _secondaryColor, width: 2),
                              ),
                              child: Icon(
                                Icons.school,
                                size: 30,
                                color: _secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 8),
                      
                      // Student Name
                      Text(
                        student['name'] ?? 'Student Name',
                        style: nameStyle,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Details Grid
                      _buildDetailRow('Admission No', student['admissionNo'] ?? '2025-001'),
                      _buildDetailRow('Class', student['class'] ?? '2(B)'),
                      _buildDetailRow('Father', student['fatherName'] ?? 'Vinod Kumar'),
                      _buildDetailRow('DOB', student['dob'] ?? '01/01/2014'),
                      
                      if (_includeBloodGroup && student['bloodGroup'] != null)
                        _buildDetailRow('Blood Group', student['bloodGroup']!),
                      
                      const SizedBox(height: 8),
                      
                      // Validity
                      Row(
                        children: [
                          _buildDetailRow('Valid From', _issueDateController.text),
                          const SizedBox(width: 20),
                          _buildDetailRow('Valid Until', _validUntilController.text),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Barcode/QR Code
                      if (_includeBarcode || _includeQRCode)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_includeBarcode)
                              Container(
                                width: 120,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'BARCODE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            
                            if (_includeQRCode)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'QR',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // ID Card Number
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _secondaryColor),
              ),
              child: Text(
                'ID: ${student['admissionNo'] ?? '000000'}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIDCardBack() {
    return Container(
      width: 340,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern based on template
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getBackgroundGradient(),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'STUDENT IDENTITY CARD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // School Address
                if (_includeAddress)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School Address:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'City Public School, Manipur\nEmail: pedagogin@example.com\nPhone: 010/12014',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 16),
                
                // Emergency Contact
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IN CASE OF EMERGENCY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contact School Office: 010/12014',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Authorized Signatory
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _authorizedByController.text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    Text(
                      'Authorized Signatory',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Footer Note
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'This card is property of City Public School',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getBackgroundGradient() {
    switch (_selectedIDCardTemplate) {
      case 'Classic':
        return [
          const Color(0xFFEFEBE9),
          const Color(0xFFD7CCC8),
        ];
      case 'Professional':
        return [
          const Color(0xFFECEFF1),
          const Color(0xFFCFD8DC),
        ];
      case 'Colorful':
        return [
          Colors.purple.shade50,
          Colors.purple.shade100,
        ];
      case 'Minimal':
        return [
          Colors.white,
          Colors.grey.shade50,
        ];
      default: // Modern
        return [
          _primaryColor.withOpacity(0.1),
          _secondaryColor.withOpacity(0.05),
        ];
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isIssueDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? _issueDate : (_validUntilDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
          _issueDateController.text = DateFormat('dd/MM/yyyy').format(_issueDate);
        } else {
          _validUntilDate = picked;
          _validUntilController.text = DateFormat('dd/MM/yyyy').format(_validUntilDate!);
        }
      });
    }
  }

  void _previewIDCard(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(40),
        child: SizedBox(
          width: 600,
          height: 700,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID Card Preview - ${student['name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Template: $_selectedIDCardTemplate',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIDCardFront(student),
                      if (_selectedPrintType == 'Double Side') ...[
                        const SizedBox(height: 40),
                        const Text(
                          'Back Side',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildIDCardBack(),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        _downloadIDCard(student);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Download This Card'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateSingleIDCard(List<Map<String, dynamic>> students) {
    if (students.isEmpty) {
      _showMessage('No student selected for ID card generation');
      return;
    }
    
    _showSuccessMessage('ID card generated successfully!');
  }

  void _generateAllIDCards(List<Map<String, dynamic>> students) {
    if (students.isEmpty) {
      _showMessage('No students selected for ID card generation');
      return;
    }
    
    _showSuccessMessage(
      '${students.length} ID cards generated successfully!',
    );
  }

  void _downloadIDCard(Map<String, dynamic> student) {
    _showSuccessMessage('Downloading ID card for ${student['name']}...');
  }

  void _downloadAllIDCards() {
    final students = widget.selectedStudents.isNotEmpty 
        ? widget.selectedStudents 
        : _sampleStudents;
    
    _showSuccessMessage(
      'Downloading all ${students.length} ID cards...',
    );
  }

  void _printAllIDCards() {
    final students = widget.selectedStudents.isNotEmpty 
        ? widget.selectedStudents 
        : _sampleStudents;
    
    _showSuccessMessage(
      'Printing all ${students.length} ID cards...',
    );
  }

  void _zoomIn() {
    _showMessage('Zoom in feature');
  }

  void _zoomOut() {
    _showMessage('Zoom out feature');
  }

  void _resetPreview() {
    setState(() {
      _primaryColor = const Color(0xFF1A237E);
      _secondaryColor = const Color(0xFF283593);
      _includePhoto = true;
      _includeBarcode = true;
      _includeSchoolLogo = true;
      _includeBloodGroup = false;
      _includeAddress = true;
      _includeQRCode = false;
      _selectedCardSize = 'Standard (85.6x54mm)';
      _selectedOrientation = 'Portrait';
      _selectedTemplate = 'Template 1';
      _selectedPrintType = 'Single Side';
      _selectedIDCardTemplate = 'Modern';
    });
    _showSuccessMessage('Preview reset to default settings');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}