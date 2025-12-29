import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentCertificateScreen extends StatefulWidget {
  const StudentCertificateScreen({Key? key}) : super(key: key);

  @override
  State<StudentCertificateScreen> createState() => _StudentCertificateScreenState();
}

class _StudentCertificateScreenState extends State<StudentCertificateScreen> {
  int _currentIndex = 1; // Show Add Certificate by default
  final List<Map<String, dynamic>> certificates = [
    {
      'name': 'Transfer Certificate',
      'backgroundImage': 'Uploaded',
      'createdDate': '15/01/2024',
      'status': 'Active',
      'templateType': 'School',
    },
    {
      'name': 'School Leaving Certificate',
      'backgroundImage': 'No Image',
      'createdDate': '10/01/2024',
      'status': 'Active',
      'templateType': 'Official',
    },
    {
      'name': 'Character Certificate',
      'backgroundImage': 'Uploaded',
      'createdDate': '05/01/2024',
      'status': 'Draft',
      'templateType': 'Simple',
    },
    {
      'name': 'Birth Certificate',
      'backgroundImage': 'Uploaded',
      'createdDate': '20/12/2023',
      'status': 'Active',
      'templateType': 'Classic',
    },
    {
      'name': 'Sports Certificate',
      'backgroundImage': 'No Image',
      'createdDate': '15/12/2023',
      'status': 'Active',
      'templateType': 'Modern',
    },
  ];
  
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _certificateNameController = TextEditingController();
  final TextEditingController _headerLeftController = TextEditingController();
  final TextEditingController _headerCenterController = TextEditingController();
  final TextEditingController _headerRightController = TextEditingController();
  final TextEditingController _bodyTextController = TextEditingController();
  final TextEditingController _footerLeftController = TextEditingController();
  final TextEditingController _footerCenterController = TextEditingController();
  final TextEditingController _footerRightController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _principalNameController = TextEditingController();
  
  // Design Settings
  bool _hasBackgroundImage = false;
  bool _studentPhotoEnabled = true;
  bool _includeWatermark = true;
  bool _showBorder = true;
  bool _includeQRCode = false;
  
  double _headerHeight = 80.0;
  double _footerHeight = 60.0;
  double _bodyHeight = 300.0;
  double _bodyWidth = 700.0;
  double _photoHeight = 100.0;
  double _borderWidth = 2.0;
  double _previewScale = 1.0; // Changed from final to mutable
  
  Color _borderColor = const Color(0xFFB71C1C);
  Color _textColor = Colors.black;
  Color _headerColor = const Color(0xFF2C3E50);
  
  String _selectedFont = 'Roboto';
  String _selectedTemplate = 'Classic';
  String _selectedPaperSize = 'A4';
  
  final List<String> _fonts = ['Roboto', 'Poppins', 'Open Sans', 'Montserrat', 'Lato'];
  final List<String> _templates = ['Classic', 'Modern', 'Elegant', 'Simple', 'Professional'];
  final List<String> _paperSizes = ['A4', 'A3', 'Letter', 'Legal'];
  
  @override
  void initState() {
    super.initState();
    _initializeForm();
  }
  
  void _initializeForm() {
    _certificateNameController.text = 'Transfer Certificate';
    _schoolNameController.text = 'SJA School';
    _headerCenterController.text = 'SCHOOL NAME';
    _principalNameController.text = 'Principal Name';
    _footerCenterController.text = 'Principal Signature';
    _bodyTextController.text = 'This is to certify that [name], son/daughter of [father_name], was a student of this school from [admission_date] to [created_at]. He/She was regular, obedient and disciplined throughout his/her stay in the school. We wish him/her success in all future endeavors.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Student Certificate Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 2,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, size: 22),
            onPressed: _exportCertificates,
            tooltip: 'Export Certificates',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, size: 22),
            onPressed: _showHelp,
            tooltip: 'Help',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildCertificateList(),
          _buildAddCertificateForm(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ========== CERTIFICATE LIST ==========

  Widget _buildCertificateList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildSectionHeader(
            title: 'Certificate Templates',
            buttonText: 'Add New',
            buttonIcon: Icons.add,
            onButtonPressed: () => setState(() => _currentIndex = 1),
          ),
          
          const SizedBox(height: 20),
          
          // Search and Filter Row
          Row(
            children: [
              Expanded(
                child: _buildSearchField(),
              ),
              const SizedBox(width: 12),
              _buildFilterButton(),
              const SizedBox(width: 8),
              _buildSortButton(),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Stats Cards
          _buildStatsCards(),
          
          const SizedBox(height: 20),
          
          // Certificate Table
          Expanded(
            child: _buildCertificateTable(),
          ),
          
          const SizedBox(height: 20),
          
          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? buttonText,
    IconData? buttonIcon,
    VoidCallback? onButtonPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          if (buttonText != null && onButtonPressed != null)
            ElevatedButton.icon(
              onPressed: onButtonPressed,
              icon: Icon(buttonIcon ?? Icons.add, size: 18),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3498DB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search certificates by name or type...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                // Implement search
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade600),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: _showFilterDialog,
        icon: Icon(Icons.filter_list, color: Colors.grey.shade700, size: 18),
        label: const Text(
          'Filter',
          style: TextStyle(color: Colors.grey),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: _showSortDialog,
        icon: Icon(Icons.sort, color: Colors.grey.shade700, size: 18),
        label: const Text(
          'Sort',
          style: TextStyle(color: Colors.grey),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            title: 'Total Templates',
            value: certificates.length.toString(),
            icon: Icons.library_books,
            color: Colors.blue,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Active',
            value: certificates.where((c) => c['status'] == 'Active').length.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'With Images',
            value: certificates.where((c) => c['backgroundImage'] == 'Uploaded').length.toString(),
            icon: Icons.image,
            color: Colors.purple,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Drafts',
            value: certificates.where((c) => c['status'] == 'Draft').length.toString(),
            icon: Icons.edit,
            color: Colors.orange,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header with horizontal scrolling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2C3E50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.5, // Adjust based on content
                child: Row(
                  children: [
                    _buildTableHeader(text: 'Certificate Name', width: 250),
                    _buildTableHeader(text: 'Status', width: 120),
                    _buildTableHeader(text: 'Template', width: 120),
                    _buildTableHeader(text: 'Image', width: 100),
                    _buildTableHeader(text: 'Created Date', width: 120),
                    _buildTableHeader(text: 'Actions', width: 250),
                  ],
                ),
              ),
            ),
          ),
          
          // Table Body with horizontal scrolling
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.5, // Adjust based on content
                child: ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    final certificate = certificates[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.white : Colors.grey[50],
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Certificate Name
                          SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  certificate['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: TEMP${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Status
                          SizedBox(
                            width: 120,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: certificate['status'] == 'Active'
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: certificate['status'] == 'Active'
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                                ),
                              ),
                              child: Text(
                                certificate['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: certificate['status'] == 'Active'
                                      ? Colors.green.shade800
                                      : Colors.orange.shade800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          
                          // Template Type
                          SizedBox(
                            width: 120,
                            child: Text(
                              certificate['templateType'],
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          // Image Status
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  certificate['backgroundImage'] == 'Uploaded'
                                      ? Icons.check_circle
                                      : Icons.remove_circle_outline,
                                  color: certificate['backgroundImage'] == 'Uploaded'
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  certificate['backgroundImage'] == 'Uploaded' ? 'Yes' : 'No',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: certificate['backgroundImage'] == 'Uploaded'
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Created Date
                          SizedBox(
                            width: 120,
                            child: Text(
                              certificate['createdDate'],
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          // Actions
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButton(
                                  icon: Icons.edit,
                                  color: Colors.blue,
                                  onPressed: () => _editCertificate(certificate),
                                  tooltip: 'Edit',
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onPressed: () => _deleteCertificate(index),
                                  tooltip: 'Delete',
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  icon: Icons.copy,
                                  color: Colors.purple,
                                  onPressed: () => _duplicateCertificate(certificate),
                                  tooltip: 'Duplicate',
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  icon: Icons.preview,
                                  color: Colors.teal,
                                  onPressed: () => _previewCertificate(certificate),
                                  tooltip: 'Preview',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader({
    required String text,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing 1 to ${certificates.length} of ${certificates.length} templates',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Text(
                  'Items per page:',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: 10,
                      items: const [
                        DropdownMenuItem<int>(value: 10, child: Text('10')),
                        DropdownMenuItem<int>(value: 25, child: Text('25')),
                        DropdownMenuItem<int>(value: 50, child: Text('50')),
                      ],
                      onChanged: (value) {},
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== ADD CERTIFICATE FORM ==========

  Widget _buildAddCertificateForm() {
    return Row(
      children: [
        // Left Panel - Form
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  title: 'Create Certificate Template',
                  buttonText: 'View Templates',
                  buttonIcon: Icons.list,
                  onButtonPressed: () => setState(() => _currentIndex = 0),
                ),
                
                const SizedBox(height: 20),
                
                // Main Form
                Column(
                  children: [
                    // Basic Information
                    _buildFormSection(
                      title: 'Basic Information',
                      icon: Icons.info,
                      children: [
                        _buildFormField(
                          label: 'Certificate Name *',
                          controller: _certificateNameController,
                          icon: Icons.title,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'School Name',
                          controller: _schoolNameController,
                          icon: Icons.school,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'Principal Name',
                          controller: _principalNameController,
                          icon: Icons.person,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Design Settings
                    _buildFormSection(
                      title: 'Design Settings',
                      icon: Icons.design_services,
                      children: [
                        _buildDropdownField(
                          label: 'Template Style',
                          value: _selectedTemplate,
                          items: _templates,
                          onChanged: (value) => setState(() => _selectedTemplate = value!),
                          icon: Icons.style,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Paper Size',
                          value: _selectedPaperSize,
                          items: _paperSizes,
                          onChanged: (value) => setState(() => _selectedPaperSize = value!),
                          icon: Icons.picture_as_pdf,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Font Family',
                          value: _selectedFont,
                          items: _fonts,
                          onChanged: (value) => setState(() => _selectedFont = value!),
                          icon: Icons.font_download,
                        ),
                        const SizedBox(height: 16),
                        
                        // Toggle Options
                        Column(
                          children: [
                            _buildToggleOption(
                              label: 'Include Student Photo',
                              value: _studentPhotoEnabled,
                              onChanged: (value) => setState(() => _studentPhotoEnabled = value!),
                              icon: Icons.photo_camera,
                            ),
                            const SizedBox(height: 12),
                            _buildToggleOption(
                              label: 'Include Watermark',
                              value: _includeWatermark,
                              onChanged: (value) => setState(() => _includeWatermark = value!),
                              icon: Icons.water_drop,
                            ),
                            const SizedBox(height: 12),
                            _buildToggleOption(
                              label: 'Show Border',
                              value: _showBorder,
                              onChanged: (value) => setState(() => _showBorder = value!),
                              icon: Icons.border_all,
                            ),
                            const SizedBox(height: 12),
                            _buildToggleOption(
                              label: 'Include QR Code',
                              value: _includeQRCode,
                              onChanged: (value) => setState(() => _includeQRCode = value!),
                              icon: Icons.qr_code,
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Header Section
                    _buildFormSection(
                      title: 'Header Section',
                      icon: Icons.format_align_center,
                      children: [
                        _buildFormField(
                          label: 'Header Left Text',
                          controller: _headerLeftController,
                          icon: Icons.format_align_left,
                        ),
                        const SizedBox(height: 12),
                        _buildFormField(
                          label: 'Header Center Text',
                          controller: _headerCenterController,
                          icon: Icons.format_align_center,
                        ),
                        const SizedBox(height: 12),
                        _buildFormField(
                          label: 'Header Right Text',
                          controller: _headerRightController,
                          icon: Icons.format_align_right,
                        ),
                        const SizedBox(height: 16),
                        _buildSliderWithLabel(
                          label: 'Header Height',
                          value: _headerHeight,
                          min: 50,
                          max: 150,
                          unit: 'px',
                          onChanged: (value) => setState(() => _headerHeight = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Body Section
                    _buildFormSection(
                      title: 'Body Content',
                      icon: Icons.text_fields,
                      children: [
                        _buildFormFieldWithLines(
                          label: 'Certificate Text *',
                          controller: _bodyTextController,
                          maxLines: 6,
                          isRequired: true,
                          icon: Icons.text_format,
                        ),
                        const SizedBox(height: 16),
                        
                        // Placeholders
                        _buildPlaceholdersSection(),
                        
                        const SizedBox(height: 16),
                        
                        // Body Dimensions
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: _buildSliderWithLabel(
                                  label: 'Body Height',
                                  value: _bodyHeight,
                                  min: 200,
                                  max: 500,
                                  unit: 'px',
                                  onChanged: (value) => setState(() => _bodyHeight = value),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: _buildSliderWithLabel(
                                  label: 'Body Width',
                                  value: _bodyWidth,
                                  min: 500,
                                  max: 900,
                                  unit: 'px',
                                  onChanged: (value) => setState(() => _bodyWidth = value),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        if (_studentPhotoEnabled) ...[
                          const SizedBox(height: 16),
                          _buildSliderWithLabel(
                            label: 'Photo Height',
                            value: _photoHeight,
                            min: 50,
                            max: 200,
                            unit: 'px',
                            onChanged: (value) => setState(() => _photoHeight = value),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Footer Section
                    _buildFormSection(
                      title: 'Footer Section',
                      icon: Icons.format_align_center,
                      children: [
                        _buildFormField(
                          label: 'Footer Left Text',
                          controller: _footerLeftController,
                          icon: Icons.format_align_left,
                        ),
                        const SizedBox(height: 12),
                        _buildFormField(
                          label: 'Footer Center Text',
                          controller: _footerCenterController,
                          icon: Icons.format_align_center,
                        ),
                        const SizedBox(height: 12),
                        _buildFormField(
                          label: 'Footer Right Text',
                          controller: _footerRightController,
                          icon: Icons.format_align_right,
                        ),
                        const SizedBox(height: 16),
                        _buildSliderWithLabel(
                          label: 'Footer Height',
                          value: _footerHeight,
                          min: 30,
                          max: 120,
                          unit: 'px',
                          onChanged: (value) => setState(() => _footerHeight = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Color Settings
                    _buildFormSection(
                      title: 'Color Settings',
                      icon: Icons.color_lens,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: _buildColorPicker(
                                  label: 'Border Color',
                                  color: _borderColor,
                                  onColorChanged: (color) => setState(() => _borderColor = color),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: _buildColorPicker(
                                  label: 'Header Color',
                                  color: _headerColor,
                                  onColorChanged: (color) => setState(() => _headerColor = color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSliderWithLabel(
                          label: 'Border Width',
                          value: _borderWidth,
                          min: 1,
                          max: 10,
                          unit: 'px',
                          onChanged: (value) => setState(() => _borderWidth = value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Background Image
                    _buildFormSection(
                      title: 'Background Image',
                      icon: Icons.image,
                      children: [
                        _buildImageUploadSection(),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    _buildFormActions(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Right Panel - Preview
        Expanded(
          flex: 2,
          child: _buildPreviewPanel(),
        ),
      ],
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: isRequired
                      ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldWithLines({
    required String label,
    required TextEditingController controller,
    required int maxLines,
    bool isRequired = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: isRequired
                      ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignLabelWithHint: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
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
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF3498DB),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderWithLabel({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: (max - min).toInt(),
                label: '${value.round()} $unit',
                activeColor: const Color(0xFF3498DB),
                inactiveColor: Colors.grey.shade300,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${value.round()} $unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
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
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildColorOption(const Color(0xFFB71C1C), onColorChanged),
                  _buildColorOption(const Color(0xFF2C3E50), onColorChanged),
                  _buildColorOption(const Color(0xFF3498DB), onColorChanged),
                  _buildColorOption(const Color(0xFF27AE60), onColorChanged),
                  _buildColorOption(const Color(0xFFF39C12), onColorChanged),
                  _buildColorOption(const Color(0xFF8E44AD), onColorChanged),
                  _buildColorOption(const Color(0xFFE74C3C), onColorChanged),
                  _buildColorOption(const Color(0xFF16A085), onColorChanged),
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
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholdersSection() {
    final placeholders = [
      '[name]',
      '[dob]',
      '[present_address]',
      '[guardian]',
      '[created_at]',
      '[admission_no]',
      '[roll_no]',
      '[class]',
      '[section]',
      '[gender]',
      '[admission_date]',
      '[category]',
      '[cast]',
      '[father_name]',
      '[mother_name]',
      '[religion]',
      '[email]',
      '[phone]',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Placeholders',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: placeholders.map((placeholder) {
                return InkWell(
                  onTap: () {
                    final cursorPosition = _bodyTextController.selection.base.offset;
                    final newText = _bodyTextController.text.replaceRange(
                      cursorPosition,
                      cursorPosition,
                      placeholder,
                    );
                    _bodyTextController.text = newText;
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Text(
                      placeholder,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Click any placeholder to insert into certificate text',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background Image',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _hasBackgroundImage = !_hasBackgroundImage),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: _hasBackgroundImage ? Colors.green : Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _hasBackgroundImage ? Colors.green.shade50 : Colors.blue.shade50,
            ),
            child: _hasBackgroundImage
                ? Stack(
                    children: [
                      // Simulated Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.shade100,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 50),
                              const SizedBox(height: 12),
                              const Text(
                                'Background Image Uploaded',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Click to change or remove',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 60, color: Colors.blue.shade700),
                      const SizedBox(height: 16),
                      const Text(
                        'Click to upload background image',
                        style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Recommended: 1200x900px (JPG, PNG, SVG)',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _hasBackgroundImage = true),
                        icon: const Icon(Icons.upload_file, size: 16),
                        label: const Text('Browse Files'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'For best results, use high-quality images with light backgrounds',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _saveCertificate,
            icon: const Icon(Icons.save, size: 20),
            label: const Text('Save Template'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: _resetForm,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Reset Form'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () => setState(() => _currentIndex = 0),
            icon: const Icon(Icons.list, size: 20),
            label: const Text('View List'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3498DB),
              side: const BorderSide(color: Color(0xFF3498DB)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Preview Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certificate Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out, size: 20),
                      onPressed: _zoomOut,
                      tooltip: 'Zoom Out',
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in, size: 20),
                      onPressed: _zoomIn,
                      tooltip: 'Zoom In',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _resetPreview,
                      tooltip: 'Reset Preview',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Certificate Preview
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildCertificatePreview(),
                ),
              ),
            ),
          ),
          
          // Preview Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scale: ${(_previewScale * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 14),
                    ),
                    ElevatedButton.icon(
                      onPressed: _generatePDF,
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Export as PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _previewScale,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: '${(_previewScale * 100).toStringAsFixed(0)}%',
                  onChanged: (value) {
                    setState(() {
                      _previewScale = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatePreview() {
    return Transform.scale(
      scale: _previewScale,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background
            if (_hasBackgroundImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade100,
                  ),
                ),
              ),
            
            // Border
            if (_showBorder)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _borderColor,
                      width: _borderWidth,
                    ),
                  ),
                ),
              ),
            
            // Watermark
            if (_includeWatermark)
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
            
            // Content
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  // Header
                  Container(
                    height: _headerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _headerLeftController.text,
                            style: TextStyle(
                              color: _headerColor,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _headerCenterController.text,
                            style: TextStyle(
                              color: _headerColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _headerRightController.text,
                            style: TextStyle(
                              color: _headerColor,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'CERTIFICATE OF COMPLETION',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _headerColor,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Body
                  Container(
                    height: _bodyHeight,
                    width: _bodyWidth,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        // Main Text
                        Positioned.fill(
                          child: SingleChildScrollView(
                            child: Text(
                              _bodyTextController.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: _textColor,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        
                        // Student Photo
                        if (_studentPhotoEnabled)
                          Positioned(
                            right: 20,
                            top: 20,
                            child: Container(
                              height: _photoHeight,
                              width: _photoHeight * 0.75,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400, width: 2),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera, size: 30, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Student Photo',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // QR Code
                        if (_includeQRCode)
                          Positioned(
                            left: 20,
                            bottom: 20,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: Center(
                                child: Icon(Icons.qr_code, size: 40, color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Footer
                  Container(
                    height: _footerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 200,
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _footerLeftController.text.isNotEmpty
                                    ? _footerLeftController.text
                                    : _principalNameController.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Principal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 200,
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _footerCenterController.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 200,
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _footerRightController.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'School Seal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3498DB),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _currentIndex == 0 ? Colors.blue.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.library_books,
                color: _currentIndex == 0 ? const Color(0xFF3498DB) : Colors.grey.shade600,
                size: 22,
              ),
            ),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _currentIndex == 1 ? Colors.blue.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _currentIndex == 1 ? Icons.add_circle : Icons.add_circle_outline,
                color: _currentIndex == 1 ? const Color(0xFF3498DB) : Colors.grey.shade600,
                size: 22,
              ),
            ),
            label: 'Create',
          ),
        ],
      ),
    );
  }

  // ========== HELPER METHODS ==========

  void _editCertificate(Map<String, dynamic> certificate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${certificate['name']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _deleteCertificate(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Certificate'),
        content: Text('Are you sure you want to delete "${certificates[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                certificates.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateCertificate(Map<String, dynamic> certificate) {
    setState(() {
      certificates.add({
        ...certificate,
        'name': '${certificate['name']} (Copy)',
        'createdDate': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate duplicated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _previewCertificate(Map<String, dynamic> certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Preview: ${certificate['name']}'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: _buildCertificatePreview(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editCertificate(certificate);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _saveCertificate() {
    if (_certificateNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter certificate name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add new certificate to list
    final newCertificate = {
      'name': _certificateNameController.text,
      'backgroundImage': _hasBackgroundImage ? 'Uploaded' : 'No Image',
      'createdDate': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'status': 'Active',
      'templateType': _selectedTemplate,
    };

    setState(() {
      certificates.insert(0, newCertificate);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Certificate "${_certificateNameController.text}" saved successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Form'),
        content: const Text('Are you sure you want to reset all changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initializeForm();
                _hasBackgroundImage = false;
                _studentPhotoEnabled = true;
                _includeWatermark = true;
                _showBorder = true;
                _includeQRCode = false;
                _headerHeight = 80.0;
                _footerHeight = 60.0;
                _bodyHeight = 300.0;
                _bodyWidth = 700.0;
                _photoHeight = 100.0;
                _borderWidth = 2.0;
                _borderColor = const Color(0xFFB71C1C);
                _headerColor = const Color(0xFF2C3E50);
                _selectedFont = 'Roboto';
                _selectedTemplate = 'Classic';
                _selectedPaperSize = 'A4';
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetPreview() {
    setState(() {
      _previewScale = 1.0;
    });
  }

  void _zoomIn() {
    setState(() {
      if (_previewScale < 2.0) {
        _previewScale += 0.1;
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_previewScale > 0.5) {
        _previewScale -= 0.1;
      }
    });
  }

  void _generatePDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating PDF...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _exportCertificates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting certificates...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Certificate Management Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to use:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Create certificate templates with custom text and design'),
              Text('• Use placeholders for student information'),
              Text('• Preview certificates in real-time'),
              Text('• Export certificates as PDF'),
              SizedBox(height: 16),
              Text(
                'Placeholders:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Use [name], [dob], [class], etc. to insert student data'),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Certificates'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter options will be implemented here'),
          ],
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

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Certificates'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sort options will be implemented here'),
          ],
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

  @override
  void dispose() {
    _searchController.dispose();
    _certificateNameController.dispose();
    _headerLeftController.dispose();
    _headerCenterController.dispose();
    _headerRightController.dispose();
    _bodyTextController.dispose();
    _footerLeftController.dispose();
    _footerCenterController.dispose();
    _footerRightController.dispose();
    _schoolNameController.dispose();
    _principalNameController.dispose();
    super.dispose();
  }
}