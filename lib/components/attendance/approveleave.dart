import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApproveLeaveScreen extends StatefulWidget {
  const ApproveLeaveScreen({super.key});

  @override
  State<ApproveLeaveScreen> createState() => _ApproveLeaveScreenState();
}

class LeaveRequest {
  final String id;
  final String studentName;
  final String studentClass;
  final String section;
  final DateTime applyDate;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final String? approvedBy;
  final String? reason;
  final int totalDays;

  LeaveRequest({
    required this.id,
    required this.studentName,
    required this.studentClass,
    required this.section,
    required this.applyDate,
    required this.fromDate,
    required this.toDate,
    required this.status,
    this.approvedBy,
    this.reason,
  }) : totalDays = toDate.difference(fromDate).inDays + 1;
}

class _ApproveLeaveScreenState extends State<ApproveLeaveScreen> {
  String? _selectedClass;
  String? _selectedSection;
  
  final TextEditingController _searchController = TextEditingController();
  
  final List<LeaveRequest> _leaveRequests = [];
  List<LeaveRequest> _filteredRequests = [];
  
  final List<String> _classes = ['Select', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  final List<String> _sections = ['Select', 'A', 'B', 'C', 'D', 'E', 'F'];
  
  final TextEditingController _newStudentNameController = TextEditingController();
  final TextEditingController _newReasonController = TextEditingController();
  String? _newClass;
  String? _newSection;
  DateTime? _newFromDate;
  DateTime? _newToDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRequests);
  }

  void _filterRequests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRequests = _leaveRequests;
      } else {
        _filteredRequests = _leaveRequests.where((request) {
          return request.studentName.toLowerCase().contains(query) ||
              request.studentClass.toLowerCase().contains(query) ||
              request.section.toLowerCase().contains(query) ||
              (request.reason?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  void _loadSampleData() {
    if (_selectedClass == null || _selectedClass == 'Select' ||
        _selectedSection == null || _selectedSection == 'Select') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Class and Section'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _leaveRequests.clear();
        _leaveRequests.addAll([
          LeaveRequest(
            id: '1',
            studentName: 'John Doe',
            studentClass: _selectedClass!,
            section: _selectedSection!,
            applyDate: DateTime.now().subtract(const Duration(days: 2)),
            fromDate: DateTime.now().add(const Duration(days: 1)),
            toDate: DateTime.now().add(const Duration(days: 3)),
            status: 'Pending',
            reason: 'Family function',
          ),
          LeaveRequest(
            id: '2',
            studentName: 'Jane Smith',
            studentClass: _selectedClass!,
            section: _selectedSection!,
            applyDate: DateTime.now().subtract(const Duration(days: 5)),
            fromDate: DateTime.now().add(const Duration(days: 2)),
            toDate: DateTime.now().add(const Duration(days: 4)),
            status: 'Approved',
            approvedBy: 'Admin',
            reason: 'Medical checkup',
          ),
          LeaveRequest(
            id: '3',
            studentName: 'Robert Johnson',
            studentClass: _selectedClass!,
            section: _selectedSection!,
            applyDate: DateTime.now().subtract(const Duration(days: 7)),
            fromDate: DateTime.now().subtract(const Duration(days: 2)),
            toDate: DateTime.now().add(const Duration(days: 1)),
            status: 'Disapproved',
            approvedBy: 'Principal',
            reason: 'Personal work',
          ),
        ]);
        _filteredRequests = _leaveRequests;
      });
    });
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
            Row(
              children: [
                Expanded(
                  child: Column(
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _loadSampleData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('Load Leave Requests'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveListSection() {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Approve Leave List',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 300,
                        child: Container(
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
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: _filteredRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.table_chart_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No data available in table',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add new record or search with different criteria.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _showAddLeaveDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add New Leave Request'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 150, child: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 80, child: Text('Class', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 80, child: Text('Section', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 120, child: Text('Apply Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 120, child: Text('From Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 120, child: Text('To Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 100, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 150, child: Text('Action By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    SizedBox(width: 180, child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              ..._filteredRequests.map((request) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade200),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 150, child: Text(request.studentName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13))),
                                      SizedBox(width: 80, child: Text(request.studentClass, style: TextStyle(fontSize: 13))),
                                      SizedBox(width: 80, child: Text(request.section, style: TextStyle(fontSize: 13))),
                                      SizedBox(width: 120, child: Text(DateFormat('dd/MM/yyyy').format(request.applyDate), style: TextStyle(fontSize: 13))),
                                      SizedBox(width: 120, child: Text(DateFormat('dd/MM/yyyy').format(request.fromDate), style: TextStyle(fontSize: 13))),
                                      SizedBox(
                                        width: 120,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(DateFormat('dd/MM/yyyy').format(request.toDate), style: TextStyle(fontSize: 13)),
                                            Text(
                                              '(${request.totalDays} ${request.totalDays == 1 ? 'day' : 'days'})',
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(request.status).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: _getStatusColor(request.status)),
                                          ),
                                          child: Text(
                                            request.status,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: _getStatusColor(request.status),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          request.approvedBy ?? '-',
                                          style: TextStyle(
                                            color: request.approvedBy != null ? Colors.black : Colors.grey,
                                            fontStyle: request.approvedBy != null ? FontStyle.normal : FontStyle.italic,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Row(
                                          children: [
                                            if (request.status == 'Pending') ...[
                                              IconButton(
                                                icon: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                                onPressed: () => _approveLeave(request.id),
                                                tooltip: 'Approve',
                                                padding: const EdgeInsets.all(4),
                                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                                                onPressed: () => _disapproveLeave(request.id),
                                                tooltip: 'Disapprove',
                                                padding: const EdgeInsets.all(4),
                                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              ),
                                            ],
                                            IconButton(
                                              icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                              onPressed: () => _viewLeaveDetails(request),
                                              tooltip: 'View Details',
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                                              onPressed: () => _deleteLeave(request.id),
                                              tooltip: 'Delete',
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            
            Container(
              margin: const EdgeInsets.all(16),
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
                      'Records: ${_filteredRequests.isEmpty ? 0 : 1} to ${_filteredRequests.length} of ${_filteredRequests.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
                        onPressed: () {},
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB71C1C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onPressed: () {},
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
      case 'Approved':
        return Colors.green;
      case 'Disapproved':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAddLeaveDialog() {
    _newStudentNameController.clear();
    _newReasonController.clear();
    _newClass = null;
    _newSection = null;
    _newFromDate = null;
    _newToDate = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add New Leave Request',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _newStudentNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Student Name *',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Class *', style: TextStyle(fontSize: 14)),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.shade400),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                          value: _newClass,
                                                          isExpanded: true,
                                                          hint: const Text('Select Class'),
                                                          items: _classes.where((c) => c != 'Select').map((String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String? newValue) {
                                                            setDialogState(() => _newClass = newValue);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Section *', style: TextStyle(fontSize: 14)),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.shade400),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                          value: _newSection,
                                                          isExpanded: true,
                                                          hint: const Text('Select Section'),
                                                          items: _sections.where((s) => s != 'Select').map((String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String? newValue) {
                                                            setDialogState(() => _newSection = newValue);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    final date = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                                    );
                                                    if (date != null) {
                                                      setDialogState(() => _newFromDate = date);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade400),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.calendar_today, size: 20),
                                                        const SizedBox(width: 8),
                                                        Flexible(
                                                          child: Text(
                                                            _newFromDate != null
                                                                ? DateFormat('dd/MM/yyyy').format(_newFromDate!)
                                                                : 'From Date *',
                                                            style: TextStyle(
                                                              color: _newFromDate != null ? Colors.black : Colors.grey,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    final date = await showDatePicker(
                                                      context: context,
                                                      initialDate: _newFromDate ?? DateTime.now(),
                                                      firstDate: _newFromDate ?? DateTime.now(),
                                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                                    );
                                                    if (date != null) {
                                                      setDialogState(() => _newToDate = date);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade400),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.calendar_today, size: 20),
                                                        const SizedBox(width: 8),
                                                        Flexible(
                                                          child: Text(
                                                            _newToDate != null
                                                                ? DateFormat('dd/MM/yyyy').format(_newToDate!)
                                                                : 'To Date *',
                                                            style: TextStyle(
                                                              color: _newToDate != null ? Colors.black : Colors.grey,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _newReasonController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Reason for Leave *',
                                      border: OutlineInputBorder(),
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_validateNewLeaveForm()) {
                                            final newRequest = LeaveRequest(
                                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                                              studentName: _newStudentNameController.text,
                                              studentClass: _newClass!,
                                              section: _newSection!,
                                              applyDate: DateTime.now(),
                                              fromDate: _newFromDate!,
                                              toDate: _newToDate!,
                                              status: 'Pending',
                                              reason: _newReasonController.text,
                                            );

                                            setState(() {
                                              _leaveRequests.add(newRequest);
                                              _filteredRequests = _leaveRequests;
                                            });

                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Leave request added successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFB71C1C),
                                        ),
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  bool _validateNewLeaveForm() {
    if (_newStudentNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter student name'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_newClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select class'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_newSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select section'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_newFromDate == null || _newToDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both from and to dates'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_newToDate!.isBefore(_newFromDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('To date cannot be before from date'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_newReasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter reason for leave'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void _approveLeave(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Leave'),
        content: const Text('Are you sure you want to approve this leave request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                final index = _leaveRequests.indexWhere((r) => r.id == id);
                if (index != -1) {
                  _leaveRequests[index] = LeaveRequest(
                    id: _leaveRequests[index].id,
                    studentName: _leaveRequests[index].studentName,
                    studentClass: _leaveRequests[index].studentClass,
                    section: _leaveRequests[index].section,
                    applyDate: _leaveRequests[index].applyDate,
                    fromDate: _leaveRequests[index].fromDate,
                    toDate: _leaveRequests[index].toDate,
                    status: 'Approved',
                    approvedBy: 'Admin',
                    reason: _leaveRequests[index].reason,
                  );
                  _filteredRequests = _leaveRequests;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave request approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _disapproveLeave(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disapprove Leave'),
        content: const Text('Are you sure you want to disapprove this leave request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                final index = _leaveRequests.indexWhere((r) => r.id == id);
                if (index != -1) {
                  _leaveRequests[index] = LeaveRequest(
                    id: _leaveRequests[index].id,
                    studentName: _leaveRequests[index].studentName,
                    studentClass: _leaveRequests[index].studentClass,
                    section: _leaveRequests[index].section,
                    applyDate: _leaveRequests[index].applyDate,
                    fromDate: _leaveRequests[index].fromDate,
                    toDate: _leaveRequests[index].toDate,
                    status: 'Disapproved',
                    approvedBy: 'Admin',
                    reason: _leaveRequests[index].reason,
                  );
                  _filteredRequests = _leaveRequests;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave request disapproved'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Disapprove'),
          ),
        ],
      ),
    );
  }

  void _viewLeaveDetails(LeaveRequest request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Leave Request Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Student Name', request.studentName),
                  _buildDetailRow('Class & Section', '${request.studentClass} - ${request.section}'),
                  _buildDetailRow('Apply Date', DateFormat('dd/MM/yyyy').format(request.applyDate)),
                  _buildDetailRow('Leave Period', '${DateFormat('dd/MM/yyyy').format(request.fromDate)} to ${DateFormat('dd/MM/yyyy').format(request.toDate)}'),
                  _buildDetailRow('Total Days', '${request.totalDays} ${request.totalDays == 1 ? 'day' : 'days'}'),
                  _buildDetailRow('Status', request.status),
                  if (request.approvedBy != null)
                    _buildDetailRow('Action By', request.approvedBy!),
                  _buildDetailRow('Reason', request.reason ?? 'No reason provided'),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _deleteLeave(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Leave Request'),
        content: const Text('Are you sure you want to delete this leave request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _leaveRequests.removeWhere((r) => r.id == id);
                _filteredRequests = _leaveRequests;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave request deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Approve Leave',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddLeaveDialog,
            tooltip: 'Add New Leave',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedClass = null;
                _selectedSection = null;
                _searchController.clear();
                _leaveRequests.clear();
                _filteredRequests.clear();
              });
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLeaveDialog,
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectCriteriaSection(),
            const SizedBox(height: 20),
            _buildLeaveListSection(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newStudentNameController.dispose();
    _newReasonController.dispose();
    super.dispose();
  }
}     