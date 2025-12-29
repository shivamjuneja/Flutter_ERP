import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class GenerateCertificateFinalScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedStudents;
  final String certificateType;

  const GenerateCertificateFinalScreen({
    Key? key,
    required this.selectedStudents,
    required this.certificateType,
  }) : super(key: key);

  @override
  State<GenerateCertificateFinalScreen> createState() => _GenerateCertificateFinalScreenState();
}

class _GenerateCertificateFinalScreenState extends State<GenerateCertificateFinalScreen> {
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _validUntilController = TextEditingController();
  final TextEditingController _principalNameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  
  DateTime _issueDate = DateTime.now();
  DateTime? _validUntilDate;
  
  bool _includeSignature = true;
  bool _includeSeal = true;
  bool _includeBorder = true;
  bool _isWatermark = true;
  
  String _selectedPaperSize = 'A4';
  String _selectedOrientation = 'Portrait';
  String _selectedTemplate = 'Template 1';
  
  final List<String> _paperSizes = ['A4', 'A3', 'Letter', 'Legal'];
  final List<String> _orientations = ['Portrait', 'Landscape'];
  final List<String> _templates = ['Template 1', 'Template 2', 'Template 3', 'Custom'];
  
  Color _borderColor = Colors.blue.shade800;
  Color _textColor = Colors.black;
  Color _headerColor = const Color(0xFF2C3E50);

  @override
  void initState() {
    super.initState();
    _issueDateController.text = DateFormat('dd/MM/yyyy').format(_issueDate);
    _principalNameController.text = 'Principal Name';
    _remarksController.text = 'This certificate is issued in recognition of the student\'s performance.';
    
    // Set default valid until date (6 months from now)
    _validUntilDate = DateTime.now().add(const Duration(days: 180));
    _validUntilController.text = DateFormat('dd/MM/yyyy').format(_validUntilDate!);
  }

  @override
  void dispose() {
    _issueDateController.dispose();
    _validUntilController.dispose();
    _principalNameController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Generate ${widget.certificateType}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadAllCertificates,
            tooltip: 'Download All',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printAllCertificates,
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
                    
                    // Certificate Details
                    _buildSettingsCard(
                      title: 'Certificate Details',
                      children: [
                        _buildDateField(
                          label: 'Issue Date*',
                          controller: _issueDateController,
                          onTap: () => _selectDate(context, isIssueDate: true),
                        ),
                        const SizedBox(height: 12),
                        _buildDateField(
                          label: 'Valid Until',
                          controller: _validUntilController,
                          onTap: () => _selectDate(context, isIssueDate: false),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Principal Name*',
                          controller: _principalNameController,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          label: 'Remarks',
                          controller: _remarksController,
                          icon: Icons.note,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Design Settings
                    _buildSettingsCard(
                      title: 'Design Settings',
                      children: [
                        _buildCheckboxOption(
                          label: 'Include Signature',
                          value: _includeSignature,
                          onChanged: (value) => setState(() => _includeSignature = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include School Seal',
                          value: _includeSeal,
                          onChanged: (value) => setState(() => _includeSeal = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Include Border',
                          value: _includeBorder,
                          onChanged: (value) => setState(() => _includeBorder = value!),
                        ),
                        _buildCheckboxOption(
                          label: 'Watermark',
                          value: _isWatermark,
                          onChanged: (value) => setState(() => _isWatermark = value!),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          label: 'Paper Size',
                          value: _selectedPaperSize,
                          items: _paperSizes,
                          onChanged: (value) => setState(() => _selectedPaperSize = value!),
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
                        _buildColorPicker(
                          label: 'Border Color',
                          color: _borderColor,
                          onColorChanged: (color) => setState(() => _borderColor = color),
                        ),
                        const SizedBox(height: 8),
                        _buildColorPicker(
                          label: 'Header Color',
                          color: _headerColor,
                          onColorChanged: (color) => setState(() => _headerColor = color),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Selected Students
                    _buildSettingsCard(
                      title: 'Selected Students (${widget.selectedStudents.length})',
                      children: [
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            itemCount: widget.selectedStudents.length,
                            itemBuilder: (context, index) {
                              final student = widget.selectedStudents[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  student['name'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Class: ${student['class'] ?? ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.preview, size: 20),
                                  onPressed: () => _previewCertificate(student),
                                  tooltip: 'Preview',
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
                          'Certificate Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Row(
                          children: [
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
                  
                  // Certificate Preview
                  Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(20),
                        child: _buildCertificatePreview(),
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
          'Certificate Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize your ${widget.certificateType}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                color: Color(0xFF2C3E50),
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
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
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
                  _buildColorOption(Colors.blue.shade800, onColorChanged),
                  _buildColorOption(Colors.red.shade800, onColorChanged),
                  _buildColorOption(Colors.green.shade800, onColorChanged),
                  _buildColorOption(Colors.purple.shade800, onColorChanged),
                  _buildColorOption(Colors.orange.shade800, onColorChanged),
                  _buildColorOption(Colors.teal.shade800, onColorChanged),
                  _buildColorOption(Colors.brown.shade800, onColorChanged),
                  _buildColorOption(Colors.indigo.shade800, onColorChanged),
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _generateSingleCertificate,
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Current'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
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
            onPressed: _generateAllCertificates,
            icon: const Icon(Icons.batch_prediction, size: 20),
            label: const Text('Generate All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
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

  Widget _buildCertificatePreview() {
    // Sample student for preview
    final sampleStudent = widget.selectedStudents.isNotEmpty 
        ? widget.selectedStudents.first 
        : {
            'name': 'John Doe',
            'class': '10th',
            'fatherName': 'Robert Doe',
            'admissionNo': '2024001',
            'dob': '01/01/2010',
          };

    return Stack(
      children: [
        // Watermark
        if (_isWatermark)
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Center(
                child: Transform.rotate(
                  angle: -0.5,
                  child: Text(
                    'SJA SCHOOL',
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ),
        
        // Certificate Border
        if (_includeBorder)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _borderColor,
                  width: 12,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        
        // Certificate Content
        Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Column(
                children: [
                  Text(
                    'SJA MICROFOUNDATION SCHOOL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _headerColor,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Affiliated to CBSE, New Delhi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 2,
                    color: _headerColor,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Certificate Title
              Text(
                widget.certificateType.toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Certificate Body
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'This is to certify that',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      sampleStudent['name'] ?? 'Student Name',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Son/Daughter of ${sampleStudent['fatherName'] ?? 'Father Name'}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _remarksController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Details Table
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 40,
                        runSpacing: 16,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          _buildDetailItem('Admission No', sampleStudent['admissionNo'] ?? 'N/A'),
                          _buildDetailItem('Class', sampleStudent['class'] ?? 'N/A'),
                          _buildDetailItem('Date of Birth', sampleStudent['dob'] ?? 'N/A'),
                          _buildDetailItem('Issue Date', _issueDateController.text),
                          if (_validUntilController.text.isNotEmpty)
                            _buildDetailItem('Valid Until', _validUntilController.text),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Footer with Signatures
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Principal Signature
                  if (_includeSignature)
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _principalNameController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Principal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  
                  // School Seal
                  if (_includeSeal)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SEAL',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'SJA SCHOOL',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Date
                  Column(
                    children: [
                      Container(
                        width: 200,
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _issueDateController.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
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

  void _previewCertificate(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Preview - ${student['name']}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: _buildCertificatePreview(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _downloadCertificate(student);
              Navigator.pop(context);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _generateSingleCertificate() {
    if (widget.selectedStudents.isEmpty) {
      _showMessage('No student selected for certificate generation');
      return;
    }
    
    _showSuccessMessage('Certificate generated successfully!');
  }

  void _generateAllCertificates() {
    if (widget.selectedStudents.isEmpty) {
      _showMessage('No students selected for certificate generation');
      return;
    }
    
    _showSuccessMessage(
      '${widget.selectedStudents.length} certificates generated successfully!',
    );
  }

  void _downloadCertificate(Map<String, dynamic> student) {
    _showSuccessMessage('Downloading certificate for ${student['name']}...');
  }

  void _downloadAllCertificates() {
    _showSuccessMessage(
      'Downloading all ${widget.selectedStudents.length} certificates...',
    );
  }

  void _printAllCertificates() {
    _showSuccessMessage(
      'Printing all ${widget.selectedStudents.length} certificates...',
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
      _borderColor = Colors.blue.shade800;
      _headerColor = const Color(0xFF2C3E50);
      _includeSignature = true;
      _includeSeal = true;
      _includeBorder = true;
      _isWatermark = true;
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