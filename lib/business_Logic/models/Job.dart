import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  int availableSpots;
  Timestamp date;
  String description;
  String employerUid;
  GeoPoint location;
  int salary;
  String per;
  List<dynamic> signedWorkers;
  List<dynamic> approvedWorkers;
  String title;
  String major;
  String imageUrl;
  String district;
  int amountNeeded;
  String uid;

  Job(
      {required this.availableSpots,
      required this.date,
      required this.description,
      required this.employerUid,
      required this.location,
      required this.salary,
      required this.per,
      required this.signedWorkers,
      required this.title,
      required this.major,
      required this.imageUrl,
      required this.district,
      required this.approvedWorkers,
      required this.amountNeeded,
      this.uid = "none"});

  Map<String, dynamic> toMap() {
    return {
      "availableSpots": availableSpots,
      "date": date,
      "description": description,
      "employerUid": employerUid,
      "location": location,
      "salary": salary,
      "per": per,
      "signedWorkers": signedWorkers,
      "title": title,
      "major": major,
      "imageUrl": imageUrl,
      "district": district,
      "approvedWorkers": approvedWorkers,
      "amountNeeded": amountNeeded,
      "uid": uid
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
      per: job["per"],
      signedWorkers: job["signedWorkers"],
      title: job["title"],
      major: job["major"],
      imageUrl: job["imageUrl"],
      district: job["district"],
      approvedWorkers: job["approvedWorkers"],
      amountNeeded: job["amountNeeded"],
      uid: job["uid"],
    );
  }
}
