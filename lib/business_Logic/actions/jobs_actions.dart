import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data_access/firestore_dal.dart';
import '../models/Job.dart';

class JobsActions {
  final DataAccessService das = DataAccessService();
  static List<String> majors = [];
  static int selectedMajorIndex = 0;

  List<Job> getJobsOfTab(String majorTab) {
    switch (selectedMajorIndex) {
      // case 0:
      //   return [];
      // case 1:
      //   return [];
      // case 2:
      //   return [];
      // case 3:
      //   return [];
      // case 4:
      //   return [];
      default:
        return [
          Job(
              availableSpots: 5,
              date: Timestamp.fromDate(DateTime.now()),
              description:
                  'We are looking for a highly skilled software developer to join our team. The ideal candidate will have experience with Dart and Flutter, and a passion for creating intuitive, user-friendly applications.',
              employerUid: '12345',
              location: GeoPoint(37.7749, -122.4194),
              salary: 100000,
              signedWorkers: ['worker1', 'worker2'],
              title: 'Software Developer',
              major: 'Computer Science',
              imageUrl:
                  'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
              district: 'Downtown'),
          Job(
              availableSpots: 3,
              date: Timestamp.fromDate(DateTime.now()),
              description:
                  'Our company is seeking a talented graphic designer to join our team. The successful candidate will have a strong portfolio of work, and experience with Adobe Creative Suite.',
              employerUid: '67890',
              location: GeoPoint(40.7128, -74.0060),
              salary: 75000,
              signedWorkers: ['worker3', 'worker4'],
              title: 'Graphic Designer',
              major: 'Graphic Design',
              imageUrl:
                  'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
              district: 'Midtown'),
          Job(
              availableSpots: 2,
              date: Timestamp.fromDate(DateTime.now()),
              description:
                  'We are looking for an experienced project manager to oversee the development of our new product. The ideal candidate will have excellent communication skills and a track record of successfully delivering projects on time and within budget.',
              employerUid: '23456',
              location: GeoPoint(41.8781, -87.6298),
              salary: 90000,
              signedWorkers: ['worker5', 'worker6'],
              title: 'Project Manager',
              major: 'Business',
              imageUrl:
                  'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
              district: 'Downtown'),
          Job(
            availableSpots: 4,
            date: Timestamp.fromDate(DateTime.now()),
            description:
                'Our company is seeking a highly motivated and organized administrative assistant to join our team. The successful candidate will have excellent communication skills, proficiency in Microsoft Office, and the ability to multitask.',
            employerUid: '34567',
            location: GeoPoint(34.0522, -118.2437),
            salary: 50000,
            signedWorkers: ['worker7', 'worker8'],
            title: 'Administrative Assistant',
            major: 'Business',
            imageUrl:
                'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
            district: 'California',
          ),
        ];
    }
  }

  Future<List<String>> getJobsMajors() async {
    if (majors.isEmpty) {
      majors = await das.getJobsMajors();
      majors.remove("For you");
      majors.insert(0, "For You");
    }
    return majors;
  }

  void uploadJobImage() {}
}
