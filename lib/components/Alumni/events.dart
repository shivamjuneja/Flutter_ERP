import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define AddEventScreen class since it's being used in navigation
class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        backgroundColor: const Color(0xFFB71C1C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Event Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Class Section (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Pass Out Session (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add event logic here
                  Navigator.pop(context); // Go back after adding
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Event',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class Event {
  final String id;
  final String title;
  final String? classSection;
  final String? passOutSession;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;

  Event({
    required this.id,
    required this.title,
    this.classSection,
    this.passOutSession,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime _currentMonth = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadSampleEvents();
    _searchController.addListener(_filterEvents);
  }

  void _loadSampleEvents() {
    setState(() {
      _events = [
        Event(
          id: '1',
          title: 'hdf',
          fromDate: DateTime(2025, 12, 10),
          toDate: DateTime(2025, 12, 13),
          classSection: null,
          passOutSession: null,
          status: 'Active',
        ),
        Event(
          id: '2',
          title: 'events',
          classSection: '3 B',
          passOutSession: '2025-26',
          fromDate: DateTime(2025, 12, 10),
          toDate: DateTime(2025, 12, 14),
          status: 'Active',
        ),
      ];
      _filteredEvents = _events;
    });
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = _events;
      } else {
        _filteredEvents = _events.where((event) {
          return event.title.toLowerCase().contains(query) ||
              (event.classSection?.toLowerCase().contains(query) ?? false) ||
              (event.passOutSession?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  List<List<int?>> _generateCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    int startingWeekday = firstDay.weekday % 7;

    final previousMonthLastDay = DateTime(month.year, month.month, 0);
    List<List<int?>> calendar = [];
    List<int?> week = [];

    for (int i = startingWeekday - 1; i >= 0; i--) {
      week.add(previousMonthLastDay.day - i);
    }
    week = week.reversed.toList();

    for (int day = 1; day <= lastDay.day; day++) {
      week.add(day);
      if (week.length == 7) {
        calendar.add(week);
        week = [];
      }
    }

    int nextDay = 1;
    while (week.length < 7) {
      week.add(nextDay++);
    }
    if (week.isNotEmpty) calendar.add(week);

    return calendar;
  }

  bool _hasEventOnDate(int day) {
    final checkDate = DateTime(_currentMonth.year, _currentMonth.month, day);
    return _events.any((event) =>
        (checkDate.isAfter(event.fromDate.subtract(const Duration(days: 1))) &&
            checkDate.isBefore(event.toDate.add(const Duration(days: 1)))));
  }

  String? _getEventTitleForDate(int day) {
    final checkDate = DateTime(_currentMonth.year, _currentMonth.month, day);
    try {
      final event = _events.firstWhere(
        (event) =>
            checkDate.isAfter(event.fromDate.subtract(const Duration(days: 1))) &&
            checkDate.isBefore(event.toDate.add(const Duration(days: 1))),
      );
      return event.title;
    } catch (e) {
      return null;
    }
  }

  Widget _buildEventTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 56,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 80,
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14,
          ),
          dataTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
          columns: const [
            DataColumn(label: Text('Event Title'), numeric: false),
            DataColumn(label: Text('Class Section'), numeric: false),
            DataColumn(label: Text('Pass Out Session'), numeric: false),
            DataColumn(label: Text('From'), numeric: false),
            DataColumn(label: Text('To'), numeric: false),
            DataColumn(label: Text('Action'), numeric: false),
          ],
          rows: _filteredEvents.map((event) {
            return DataRow(cells: [
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(
                    event.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: Text(event.classSection ?? 'All'),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: Text(event.passOutSession ?? 'All'),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(DateFormat('dd/MM/yyyy').format(event.fromDate)),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(DateFormat('dd/MM/yyyy').format(event.toDate)),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _editEvent(event),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _deleteEvent(event.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventListSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Table with vertical scrolling
            Expanded(
              child: _filteredEvents.isEmpty
                  ? const Center(
                      child: Text(
                        'No events found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      child: _buildEventTable(),
                    ),
            ),

            // Records count and pagination
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Records: ${_filteredEvents.isEmpty ? 0 : 1} to ${_filteredEvents.length} of ${_filteredEvents.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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

  Widget _buildCalendarSection() {
    final days = _generateCalendarDays(_currentMonth);
    final currentDate = DateTime.now();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Month Navigation
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Text(
                    '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Week Days Header
            Row(
              children: _weekDays.map((day) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Calendar Days Grid with scrolling
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: days.map((week) {
                    return Row(
                      children: week.map((day) {
                        final isCurrentMonth = day != null &&
                            day <= DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
                        final isToday = isCurrentMonth &&
                            day == currentDate.day &&
                            _currentMonth.month == currentDate.month &&
                            _currentMonth.year == currentDate.year;

                        final hasEvent = isCurrentMonth && day != null && _hasEventOnDate(day);
                        final eventTitle = isCurrentMonth && day != null ? _getEventTitleForDate(day) : null;

                        return Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: isToday
                                  ? const Color(0xFFB71C1C).withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    day?.toString() ?? '',
                                    style: TextStyle(
                                      color: isCurrentMonth ? Colors.black : Colors.grey,
                                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (hasEvent && eventTitle != null)
                                    Flexible(
                                      child: Text(
                                        eventTitle,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Add Event Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEventScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _editEvent(Event event) {
    final titleController = TextEditingController(text: event.title);
    final classController = TextEditingController(text: event.classSection ?? '');
    final sessionController = TextEditingController(text: event.passOutSession ?? '');
    DateTime selectedFromDate = event.fromDate;
    DateTime selectedToDate = event.toDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Event'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: classController,
                    decoration: const InputDecoration(
                      labelText: 'Class Section',
                      border: OutlineInputBorder(),
                      hintText: 'Optional - leave blank for all',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: sessionController,
                    decoration: const InputDecoration(
                      labelText: 'Pass Out Session',
                      border: OutlineInputBorder(),
                      hintText: 'Optional - leave blank for all',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedFromDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setDialogState(() {
                                selectedFromDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(DateFormat('dd/MM/yyyy').format(selectedFromDate)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedToDate,
                              firstDate: selectedFromDate,
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setDialogState(() {
                                selectedToDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(DateFormat('dd/MM/yyyy').format(selectedToDate)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter event title'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (selectedToDate.isBefore(selectedFromDate)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('End date must be after start date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  final index = _events.indexWhere((e) => e.id == event.id);
                  if (index != -1) {
                    _events[index] = Event(
                      id: event.id,
                      title: titleController.text,
                      classSection: classController.text.isEmpty ? null : classController.text,
                      passOutSession: sessionController.text.isEmpty ? null : sessionController.text,
                      fromDate: selectedFromDate,
                      toDate: selectedToDate,
                      status: 'Active',
                    );
                    _filterEvents();
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteEvent(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _events.removeWhere((event) => event.id == id);
                _filterEvents();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event deleted successfully'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Event List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: screenWidth > 800
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Section
                  SizedBox(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.8,
                    child: _buildCalendarSection(),
                  ),
                  const SizedBox(width: 16),

                  // Event List Section
                  Expanded(
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: _buildEventListSection(),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.45,
                      child: _buildCalendarSection(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: screenHeight * 0.45,
                      child: _buildEventListSection(),
                    ),
                  ],
                ),
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