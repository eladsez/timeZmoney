import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  int availableSpots;
  Timestamp date;
  String description;
  String employerUid;
  GeoPoint location;
  int salary;
  List<dynamic> signedWorkers;
  String title;
  String major;
  String imageUrl;
  String district;

  Job(
      {required this.availableSpots,
      required this.date,
      required this.description,
      required this.employerUid,
      required this.location,
      required this.salary,
      required this.signedWorkers,
      required this.title,
      required this.major,
      required this.imageUrl,
      required this.district});

  Map<String, dynamic> toMap() {
    return {
      "availableSpots": availableSpots,
      "date": date,
      "description": description,
      "employerUid": employerUid,
      "location": location,
      "salary": salary,
      "signedWorkers": signedWorkers,
      "title": title,
      "major": major,
      "imageUrl": imageUrl,
      "district": district
    };
  }

  static Job fromMap(Map<String, dynamic> job) {
    return Job(
      availableSpots: job["availableSpots"],
      date: job["date"],
      description: job["description"],
      employerUid: job["employerUid"],
      location: job["location"],
      salary: job["salary"],
      signedWorkers: job["signedWorkers"],
      title: job["title"],
      major: job["major"],
      imageUrl: job["imageUrl"],
      district: job["district"],
    );
  }
}
