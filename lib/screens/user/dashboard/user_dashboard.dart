import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/attendance_model.dart';
import '../attendance_report/attendance_report.dart';
import '../profile/user_profile.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late Size _size;
  String _attendanceStatus = '';
  bool? isDayPassed;

  @override
  void initState() {
    super.initState();
    _checkDayPassed();
  }

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
          isDayPassed != null
              ? Column(
                  children: [
                    _buildPresentButton(context),
                    const SizedBox(height: 8.0),
                    _buildLeaveButton(context),
                  ],
                )
              : const Text(
                  'Checking Attendance...',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
        onPressed: !isDayPassed! || _attendanceStatus.isNotEmpty
            ? null
            : () {
                setState(() => _attendanceStatus = 'P');
                _markAttendance();
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
        onPressed: !isDayPassed! || _attendanceStatus.isNotEmpty
            ? null
            : () {
                setState(() => _attendanceStatus = 'L');
                _markAttendance();
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

  /// mark attendance (present or leave)
  void _markAttendance() async {
    final DateTime dateTime = DateTime.now();
    final String attendanceStatus =
        _attendanceStatus == 'P' ? 'Present' : 'Leave Pending..';

    AttendanceModel attendanceModel = AttendanceModel(
      attendanceStatus: attendanceStatus,
      dateAndTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('attendance')
        .doc(
            '${DateTime.now().millisecondsSinceEpoch}_${dateTime.year}-${dateTime.month}')
        .set(attendanceModel.toMap());
  }

  // check whether the day has been passed (24 hours completed)
  void _checkDayPassed() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('attendance')
        .orderBy('dateAndTime')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      AttendanceModel model = AttendanceModel.fromMap(
        querySnapshot.docs[0].data(),
      );

      isDayPassed = model.dateAndTime.hour > 23 &&
          model.dateAndTime.minute > 59 &&
          model.dateAndTime.second > 59;

      setState(() {});
    }
  }
}
