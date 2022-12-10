import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/attendance_model.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    final querySnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('attendance')
        .get();

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(querySnapshot),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Attendance Report'),
    );
  }

  Widget _buildBody(Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateTitle(),
                _buildAttendanceStatusTitle(),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildAttendanceItems(querySnapshot),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTitle() {
    return const Text(
      'Date',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAttendanceStatusTitle() {
    return const Text(
      'Attendance Status',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAttendanceItems(
      Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot) {
    return Expanded(
      child: FutureBuilder(
          future: querySnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  AttendanceModel model = AttendanceModel.fromMap(
                    snapshot.data!.docs[index].data(),
                  );
                  return _buildRowItem(
                    date:
                        '${model.dateAndTime.day}-${model.dateAndTime.month}-${model.dateAndTime.year}',
                    attendanceStatus: model.attendanceStatus,
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildRowItem({
    required String date,
    required String attendanceStatus,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateText(date),
          _buildAttendanceStatus(attendanceStatus),
        ],
      ),
    );
  }

  Widget _buildDateText(String date) {
    return Text(
      date,
      style: const TextStyle(
        fontSize: 18.0,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAttendanceStatus(String attendanceStatus) {
    return Text(
      attendanceStatus,
      style: TextStyle(
        fontSize: 18.0,
        color: attendanceStatus == 'Present'
            ? Colors.green
            : attendanceStatus == 'Leave'
                ? Colors.blue
                : Colors.red,
      ),
    );
  }
}
