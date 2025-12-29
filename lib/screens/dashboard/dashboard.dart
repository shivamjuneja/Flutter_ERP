// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../components/custom_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Dummy User Data
  final Map<String, dynamic> userData = const {
    "name": "Shivam Asole",
    "email": "santosh@example.com",
    "role": "Super Admin",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Row(
          children: [
            Icon(Icons.school, size: 28),
            SizedBox(width: 12),
            Text(
              "Bareilly PUBLIC SCHOOL",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // PTM Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "PTM",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                // INR Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "INR",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                // Flag Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flag, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 16),
                // Calendar Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today, size: 18),
                ),
                const SizedBox(width: 12),
                // Notifications Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none, size: 18),
                ),
                const SizedBox(width: 12),
                // Profile Avatar
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(userData: userData),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // Top 4 Small Cards
              _buildSmallStatsRow(),
              const SizedBox(height: 24),

              // Big Cards Section Title
              _buildSectionTitle("FINANCIAL OVERVIEW"),
              const SizedBox(height: 16),

              // 3 Big Cards in Horizontal Scroll
              _buildBigCardsRow(),
              const SizedBox(height: 24),

              // Staff Summary Title
              _buildSectionTitle("STAFF SUMMARY"),
              const SizedBox(height: 16),

              // Staff Role Grid
              _buildStaffGrid(),
              const SizedBox(height: 20), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back, ${userData["name"]}!",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Dashboard Overview",
          style: TextStyle(
            fontSize: 22, // Reduced from 24
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16, // Reduced from 18
          fontWeight: FontWeight.w700,
          color: Colors.grey[900],
        ),
      ),
    );
  }

  // Top 4 Small Cards
  Widget _smallStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14), // Reduced from 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5), // Reduced from 6
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color), // Reduced from 18
          ),
          const SizedBox(height: 10), // Reduced from 12
          Text(
            title,
            style: const TextStyle(
              fontSize: 11, // Reduced from 12
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6), // Reduced from 8
          Text(
            value,
            style: const TextStyle(
              fontSize: 18, // Reduced from 20
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatsRow() {
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: _smallStatCard(
                "FEES AWAITING",
                "0/0",
                Icons.account_balance_wallet,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 10), // Reduced from 12
            Expanded(
              child: _smallStatCard(
                "CONVERTED LEADS",
                "0/0",
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Reduced from 12
        // Second Row
        Row(
          children: [
            Expanded(
              child: _smallStatCard(
                "STAFF PRESENT",
                "0/2",
                Icons.people,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 10), // Reduced from 12
            Expanded(
              child: _smallStatCard(
                "STUDENT PRESENT",
                "0/795",
                Icons.school,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3 Big Cards in Horizontal Scroll
  Widget _bigCard(String title, String amount, IconData icon, Color color) {
    return Container(
      width: 260, // Reduced from 280
      margin: const EdgeInsets.only(right: 12), // Reduced from 16
      padding: const EdgeInsets.all(16), // Reduced from 20
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.1)!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6), // Reduced from 8
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.white), // Reduced from 28
          ),
          const SizedBox(height: 16), // Reduced from 20
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13, // Reduced from 14
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 6), // Reduced from 8
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22, // Reduced from 26
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6), // Reduced from 8
          const Text(
            "View Details →",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11, // Reduced from 12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigCardsRow() {
    return SizedBox(
      height: 170, // Slightly increased to prevent overflow
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: [
          const SizedBox(width: 4), // Left padding
          _bigCard(
            "MONTHLY FEES",
            "₹1,45,800",
            Icons.payments,
            Colors.green.shade600,
          ),
          _bigCard(
            "MONTHLY EXPENSES",
            "₹89,500",
            Icons.receipt_long,
            Colors.red.shade600,
          ),
          _bigCard(
            "TOTAL STUDENTS",
            "795",
            Icons.school,
            Colors.blue.shade600,
          ),
          _bigCard(
            "ANNUAL REVENUE",
            "₹18,50,000",
            Icons.trending_up,
            Colors.purple.shade600,
          ),
          const SizedBox(width: 4), // Right padding
        ],
      ),
    );
  }

  // Staff Role Grid
  Widget _staffRoleCard(String role, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6), // Reduced from 8
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color), // Reduced from 28
          ),
          const SizedBox(height: 8),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11, // Reduced from 12
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 18, // Reduced from 20
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.75, // Reduced from 0.85
      mainAxisSpacing: 10, // Reduced from 12
      crossAxisSpacing: 10, // Reduced from 12
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        _staffRoleCard("ADMIN", "1", Icons.admin_panel_settings, Colors.orange),
        _staffRoleCard("TEACHER", "0", Icons.school, Colors.blue),
        _staffRoleCard("ACCOUNTANT", "0", Icons.account_balance, Colors.green),
        _staffRoleCard("LIBRARIAN", "0", Icons.menu_book, Colors.purple),
        _staffRoleCard("RECEPTIONIST", "0", Icons.headset_mic, Colors.pink),
        _staffRoleCard("SUPER ADMIN", "1", Icons.security, Colors.red),
      ],
    );
  }
}  