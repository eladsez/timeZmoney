import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import '../business_Logic/models/CustomUser.dart';

class DataAccessService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(CustomUser newUser) async {
    await _db.collection("users").add(newUser.toMap());
  }

  Future<void> updateUser(String? uid, String field, dynamic toUpdate) async {
    await _db
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get()
        .then((result) => {
              if (result.size > 0)
                {
                  result.docs.forEach((userDoc) => {
                        _db
                            .collection("users")
                            .doc(userDoc.id)
                            .update({field: toUpdate})
                      })
                }
            });
  }

  Future<CustomUser?> getCustomUser(User? currUser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("users")
        .where('uid', isEqualTo: currUser?.uid)
        .get();
    if (snapshot.docs.isEmpty) {
      print("User doesn't exist yet\n");
    } else if (snapshot.docs.isNotEmpty) {
      return CustomUser.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  /*
   * Get a CustomUser by his uid
   */
  Future<CustomUser?> getCustomUserByUid(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("users")
        .where('uid', isEqualTo: uid)
        .get();
    if (snapshot.docs.isEmpty) {
      print("User doesn't exist yet\n");
    } else if (snapshot.docs.isNotEmpty) {
      return CustomUser.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  /*
   * This function return list of string
   * the list contain the job majors available in the database
   * used to display the majors tabs
   */
  Future<List<String>> getMajors() async {
    QuerySnapshot<Map<String, dynamic>> majorsSnapshot = await _db.collection("jobsMajors").get();
    return majorsSnapshot.docs
        .map((doc) => doc.data()["major"].toString())
        .toList();
  }

  /*
   * Get the jobs the employerUid post
   */
  Future<List<Job>> getJobsOfEmployer(String employerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
    await _db.collection("jobs").where("employerUid", isEqualTo: employerUid).get();
    return jobsSnap.docs
        .map((doc) => Job.fromMap(doc.data()))
        .toList();
  }


  /*
   * This function get as an argument major of a job and return all the jobs under this major
   */
  Future<List<Job>> getJobsOfMajor(String major) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
        await _db.collection("jobs").where("major", isEqualTo: major).get();
    List<Job> jobs = [];
    for (var jobDoc in jobsSnap.docs) {
      jobs.add(Job.fromMap(jobDoc.data()));
    }
    return jobs;
  }

  /*
   * This function responsible to create a new job in the jobs collection
   */
  Future<void> createJob(Job job) async {
    if (!(await getMajors()).contains(job.major)){ // the major doesn't exist yet
      await _db.collection("jobsMajors").add({"major": job.major});
    }
    await _db.collection("jobs").add(job.toMap());
  }

  /*
   * get all the jobs in the job collection
   * TODO: should change to - all the jobs that their date not already passed
   */
  Future<List<Job>> getAllJobs() async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
    await _db.collection("jobs").get();
    List<Job> jobs = [];
    for (var jobDoc in jobsSnap.docs) {
      jobs.add(Job.fromMap(jobDoc.data()));
    }
    return jobs;
  }


}
