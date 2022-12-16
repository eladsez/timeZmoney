import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String availableSpots;
  Timestamp date;
  String description;
  String employerUid;
  GeoPoint location;
  int salary;
  List<String> signedWorkers;
  String title;
  String major;

  Job(
      {required this.availableSpots,
      required this.date,
      required this.description,
      required this.employerUid,
      required this.location,
      required this.salary,
      required this.signedWorkers,
      required this.title,
      required this.major});

  Map<String, dynamic> toMap() {
    return {};
  }

  static Job fromMap(Map<String, dynamic> job) {
    return Job(
      availableSpots: job["availableSpots"],
      date: job["date"],
      description: job["description"],
      employerUid: job["employerUid"],
      location: job["loaction"],
      salary: job["salary"],
      signedWorkers: job["signedWorkers"].map((element) => element).toList(),
      title: job["title"],
      major: job["major"],
    );
  }
}
