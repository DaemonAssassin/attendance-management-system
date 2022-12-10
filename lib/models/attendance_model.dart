class AttendanceModel {
  AttendanceModel({
    required this.dateAndTime,
    required this.attendanceStatus,
  });

  final DateTime dateAndTime;
  final String attendanceStatus;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateAndTime': dateAndTime.millisecondsSinceEpoch,
      'attendanceStatus': attendanceStatus,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      dateAndTime:
          DateTime.fromMillisecondsSinceEpoch(map['dateAndTime'] as int),
      attendanceStatus: map['attendanceStatus'] as String,
    );
  }
}
