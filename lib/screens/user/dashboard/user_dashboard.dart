import 'package:attendance_management_system/screens/user/profile/user_profile.dart';
import 'package:flutter/material.dart';
import '../attendance_report/attendance_report.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late Size _size;
  String _attendanceStatus = '';

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('User DashBoard'),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfileScreen(),
                ),
              );
            },
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/3584924/pexels-photo-3584924.jpeg?auto=compress&cs=tinysrgb&w=600',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPresentButton(context),
          const SizedBox(height: 8.0),
          _buildLeaveButton(context),
          const SizedBox(height: 8.0),
          _buildViewAttendanceButton(context),
        ],
      ),
    );
  }

  Widget _buildPresentButton(BuildContext context) {
    return SizedBox(
      width: _size.width * 0.6,
      child: ElevatedButton(
        onPressed: _attendanceStatus.isNotEmpty
            ? null
            : () {
                setState(() => _attendanceStatus = 'P');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You Marked Present'),
                  ),
                );
              },
        child: const Text('Present'),
      ),
    );
  }

  Widget _buildLeaveButton(BuildContext context) {
    return SizedBox(
      width: _size.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: _attendanceStatus.isNotEmpty
            ? null
            : () {
                setState(() => _attendanceStatus = 'L');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You Requested Leave'),
                  ),
                );
              },
        child: const Text('Leave'),
      ),
    );
  }

  Widget _buildViewAttendanceButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AttendanceReportScreen(),
          ),
        );
      },
      child: const Text('View Attendance'),
    );
  }
}
