import 'package:flutter/material.dart';

// Import your screens
import 'acadamics/classtimetable.dart';
import 'acadamics/teacherTimeTable.dart';
import 'acadamics/assignclassteacher.dart';
import 'acadamics/promotestudents.dart';
import 'acadamics/subjectgroup.dart';
import 'acadamics/subjects.dart';
import 'acadamics/addclass.dart';
import 'acadamics/section.dart';
import 'Alumni/managalumni.dart';
import 'Alumni/events.dart';
import 'attendance/dailyAttendance.dart';
import 'attendance/approveleave.dart';
import 'attendance/attendancebydate.dart';
import 'Certificate/studentcertificate.dart';
import 'Certificate/generatecertificate.dart';
import 'Certificate/generateidcard.dart';

class CustomDrawer extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CustomDrawer({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, bool> expandedModules = {};

  // Module → [Screen name, route]
  final Map<String, List<Map<String, String>>> modules = {
    "Dashboard": [
      {"name": "Home", "route": "/dashboard"},
      {"name": "Notifications", "route": "/dashboard/notifications"},
    ],
    "Academics": [
      {"name": "Dashboard", "route": "/academics/dashboard"},
      {"name": "Class Timetable", "route": "/academics/classtimetable"},
      {"name": "Teachers Timetable", "route": "/academics/teacherstimetable"},
      {"name": "Assign Class Teacher", "route": "/academics/assignclassteacher"},
      {"name": "Promote Students", "route": "/academics/promotestudents"},
      {"name": "Subject Group", "route": "/academics/subjectgroup"},
      {"name": "Subjects", "route": "/academics/subjects"},
      {"name": "Class", "route": "/academics/class"},
      {"name": "Section", "route": "/academics/section"},
    ],
    "Alumni": [
      {"name": "Directory", "route": "/alumni/ManageAlumni"},
      {"name": "Events", "route": "/alumni/events"},
      {"name": "All Events", "route": "/alumni/AllAlumni"},
    ],
    "Attendance": [
      {"name": "Daily Attendance", "route": "/attendance/daily"},
      {"name": "Approve Leave", "route": "/attendance/ApproveLeave"},
      {"name": "Attendance By Date", "route": "/attendance/AttendanceByDate"},
    ],
    "Certificates": [
      {"name": "Student Certificate", "route": "/certificates/Studentcertificate"},
      {"name": "Generate Certificate", "route": "/certificates/generatecertificate"},
      {"name": "Student ID Card", "route": "/certificates/Studentidcard"},
      {"name": "Generate Staff ID Card", "route": "/certificates/generatestaffidcard"},
      {"name": "Staff ID Card", "route": "/certificates/staffidcard"},
      {"name": "Generate ID Card", "route": "/certificates/generateidcard"},
    ],
    "Student Information": [
      {"name": "Profile", "route": "/student/profile"},
      {"name": "Guardian Info", "route": "/student/guardian"},
    ],
    "Online Examination": [
      {"name": "Exam List", "route": "/exams/list"},
      {"name": "Results", "route": "/exams/results"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: Column(
        children: [
          // Profile Header with School Branding
          Container(
            color: const Color(0xFFB71C1C),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 32, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "CITY PUBLIC SCHOOL",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ),
                  title: Text(
                    widget.userData['name'] ?? "Guest User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.userData['email'] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: modules.entries.map((entry) {
                  String moduleName = entry.key;
                  List<Map<String, String>> screens = entry.value;
                  bool isExpanded = expandedModules[moduleName] ?? false;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isExpanded ? Colors.white : Colors.transparent,
                      boxShadow: isExpanded
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: ExpansionTile(
                      leading: Icon(
                        _getModuleIcon(moduleName),
                        color: const Color(0xFFB71C1C),
                        size: 22,
                      ),
                      title: Text(
                        moduleName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedModules[moduleName] = expanded;
                        });
                      },
                      children: screens.map((screen) {
                        return Container(
                          margin: const EdgeInsets.only(left: 16, right: 8, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey[100],
                          ),
                          
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            leading: Icon(
                              Icons.arrow_right_rounded,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            title: Text(
                              screen["name"]!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              _navigateToScreen(
                                context,
                                screen["route"]!,
                                screen["name"]!,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey[700], size: 22),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigating to: Settings'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red.shade700, size: 22),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation(context);
                    },
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getModuleIcon(String moduleName) {
    switch (moduleName) {
      case "Dashboard":
        return Icons.dashboard;
      case "Academics":
        return Icons.school;
      case "Alumni":
        return Icons.people;
      case "Attendance":
        return Icons.calendar_today;
      case "Certificates":
        return Icons.assignment;
      case "Student Information":
        return Icons.person;
      case "Online Examination":
        return Icons.quiz;
      default:
        return Icons.folder;
    }
  }

  void _navigateToScreen(BuildContext context, String route, String screenName) {
    Navigator.pop(context);

    switch (route) {
      case "/academics/classtimetable":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClassTimetableScreen()),
        );
        break;

      case "/academics/teacherstimetable":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeacherTimeTable()),
        );
        break;

      case "/academics/assignclassteacher":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AssignClassTeacherScreen()),
        );
        break;

      case "/academics/promotestudents":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PromoteStudentScreen()),
        );
        break;

      case "/academics/subjectgroup":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubjectGroupScreen()),
        );
        break;

      case "/academics/Subjects":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubjectScreen()),
        );
        break;

      case "/academics/class":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddClassScreen()),
        );
        break;

      case "/academics/section":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SectionScreen()),
        );
        break;

      case "/alumni/events":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventsScreen()),
        );
        break;

      case "/alumni/ManageAlumni":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ManageAlumniScreen()),
        );
        break;

      case "/attendance/daily":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyAttendanceScreen()),
        );
        break;

      case "/attendance/ApproveLeave":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ApproveLeaveScreen()),
        );
        break;

      case "/attendance/AttendanceByDate":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceByDateScreen()),
        );
        break;

      case "/certificates/Studentcertificate":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentCertificateScreen()),
        );
        break;

      case "/certificates/generatecertificate":
        // Pass empty list - actual data will come from your backend
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenerateCertificateScreen(),
          ),
        );
        break;

      case "/certificates/generateidcard":
        // Pass empty list - actual data will come from your backend
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenerateIDCardScreen(
              selectedStudents: [], // Empty list - will be populated dynamically
            ),
          ),
        );
        break;

      case "/certificates/Studentidcard":
      case "/certificates/generatestaffidcard":
      case "/certificates/staffidcard":
        // These screens don't exist yet - you can create them later
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$screenName - Screen under development'),
            duration: const Duration(seconds: 2),
          ),
        );
        break;

      // Handle other default routes
      case "/dashboard":
      case "/dashboard/notifications":
      case "/academics/dashboard":
      case "/alumni/AllAlumni":
      case "/student/profile":
      case "/student/guardian":
      case "/exams/list":
      case "/exams/results":
        // These are placeholder routes for future implementation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$screenName feature coming soon'),
            duration: const Duration(seconds: 2),
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to: $screenName'),
            duration: const Duration(seconds: 1),
          ),
        );
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Successfully logged out"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}