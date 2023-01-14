import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import '../business_Logic/models/CustomUser.dart';
import '../business_Logic/models/Review.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ServerDataAccessService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String IP = '10.0.0.19';
  final int port = 8000;
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
      //TODO: commentted out the print statement because it was printing too much
      // print("User doesn't exist yet\n");
    } else if (snapshot.docs.isNotEmpty) {
      return CustomUser.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  /*
   * Get a CustomUser by his uid
   */
  Future<CustomUser?> getCustomUserByUid(String uid) async {
    final response = await http.get(
      Uri.parse("http://$IP:$port/"),
      headers: <String, String>{"request":"get_user_with_uid","data":uid},
    );
    if(response.statusCode != 200)
    {
      return null;
    }
    else{
      Map<String,dynamic> pre = json.decode(response.body);
      return CustomUser.fromMap(pre);
    }
  }

  /*
   * This function responsible to create a new job in the jobs collection
   */
  Future<void> createJob(Job job) async {
    if (!(await getMajors()).contains(job.major)) {
      // the major doesn't exist yet
      await _db.collection("jobsMajors").add({"major": job.major});
    }
    await _db.collection("jobs").add(job.toMap()).then((value) async {
      await _db.collection("jobs").doc(value.id).update({"uid": value.id});
      job.uid = value.id;
    });
  }

  /*
   * This function return list of string
   * the list contain the job majors available in the database
   * used to display the majors tabs
   */
  Future<List<String>> getMajors() async {
    final response = await http.get(
      Uri.parse("http://$IP:$port/"),
      headers:<String,String>{"request":"get_majors",},
    );
    var str = response.body.split(',');
    List<String> majors = [];
    for(var i in str){
      var after = i.replaceAll(RegExp('[^A-Za-z0-9 ]'),'');
      majors.add(after);
    }
    return majors;
  }

  /*
   * Get the jobs the employerUid post
   */
  Future<List<Job>> getJobsOfEmployer(String employerUid) async {
    final response = await http.get(
      Uri.parse("http://$IP:$port/"),
      headers: <String, String>{"request":"get_jobs_of_employer","data":employerUid},
    );
    Iterable iter = json.decode(response.body);
    for(var item in iter){
      var split = item['location'].split(',');
      double lat = double.parse(split[0]);
      double long = double.parse(split[1]);
      item['location'] = GeoPoint(lat,long);
    }
    List<Job> jobs = List<Job>.from(iter.map((job) => Job.fromMap(job)));
    return jobs;
  }

  /*
   * Filter jobsSnap and return the relevant jobs
   * currently relevant jobs are that its date has not passed
   */
  List<Job> filterRelevantJobs(QuerySnapshot<Map<String, dynamic>> jobsSnap) {
    List<Job> jobs = [];
    Job checkJob;
    for (var jobDoc in jobsSnap.docs) {
      checkJob = Job.fromMap(jobDoc.data());
      if (checkJob.date.compareTo(Timestamp.now()) < 0) {
        continue;
      }
      jobs.add(checkJob);
    }
    return jobs;
  }

  List<Job> filterRelevantJobsFromList(List<Job> toCheck) {
    List<Job> jobs = [];
    for (var jobDoc in toCheck) {
      if (jobDoc.date.compareTo(Timestamp.now()) < 0) {
        continue;
      }
      jobs.add(jobDoc);
    }
    return jobs;
  }

  /*
  Filter jobs according to type(future or past)
   */
  List<Job> filterJobs(QuerySnapshot<Map<String, dynamic>> jobsSnap,String type){
    List<Job> jobs = type.compareTo("future") == 0 ?
    jobsSnap.docs.map((snap) => Job.fromMap(snap.data())).where((element) => element.date.compareTo(Timestamp.now()) > 0).toList():
    jobsSnap.docs.map((snap) => Job.fromMap(snap.data())).where((element) => element.date.compareTo(Timestamp.now()) < 0).toList();
    return jobs;
  }
  /*
   * get all relevant jobs in the job collection (for you major)
   * currently relevant jobs are that its date has not passed and there is still place to insert more workers
   */
  Future<List<Job>> getAllRelevantJobs() async {
    final response = await http.get(
      Uri.parse("http://$IP:$port/"),
      headers: <String,String>{"request":"get_relevant_jobs"},
    );
    Iterable iter = json.decode(response.body);
    for(var item in iter){
      var split = item['location'].split(',');
      double lat = double.parse(split[0]);
      double long = double.parse(split[1]);
      item['location'] = GeoPoint(lat,long);
    }
    List<Job> jobs = List<Job>.from(iter.map((job) => Job.fromMap(job)));
    return filterRelevantJobsFromList(jobs);
  }

  /*
   * This function get as an argument major of a job and return all the jobs under this major
   */
  Future<List<Job>> getJobsOfMajor(String major) async {
    final response = await http.get(
      Uri.parse("http://$IP:$port/"),
      headers: <String, String>{"request":"get_relevant_jobs",},
    );
    Iterable iter = json.decode(response.body);
    for(var item in iter){
      var split = item['location'].split(',');
      double lat = double.parse(split[0]);
      double long = double.parse(split[1]);
      item['location'] = GeoPoint(lat,long);
    }
    List<Job> test = List<Job>.from(iter.map((job) => Job.fromMap(job)));
    return filterRelevantJobsFromList(test);
  }

  Future<void> addWorkerToWaitList(Job job, String uid) async {
    await _db.collection("jobs").doc(job.uid).update({
      "signedWorkers": FieldValue.arrayUnion([uid])
    });
  }

  Future<void> approveWorker(Job job, String workerUid) async {
    _db.collection("jobs").doc(job.uid).update({
      "signedWorkers": FieldValue.arrayRemove([workerUid]),
      "approvedWorkers": FieldValue.arrayUnion([workerUid])
    });
    // update the job object
    job.signedWorkers.remove(workerUid);
    job.approvedWorkers.add(workerUid);
  }

  Future<void> removeWorker(Job job, String workerUid) async {
    _db.collection("jobs").doc(job.uid).update({
      "approvedWorkers": FieldValue.arrayRemove([workerUid]),
      "signedWorkers": FieldValue.arrayUnion([workerUid])
    });
    // update the job object
    job.approvedWorkers.remove(workerUid);
    job.signedWorkers.add(workerUid);
  }

  Future<void> updateJob(String jobUid, String field, dynamic toUpdate) async {
    await _db.collection("jobs").doc(jobUid).update({field: toUpdate});
  }

  Future<Job> getJobByUid(String jobUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
        await _db.collection("jobs").where("uid", isEqualTo: jobUid).get();
    return Job.fromMap(jobsSnap.docs.first.data());
  }

  /*
  Get all the jobs the worker user with this uid did in the past
   */
  Future<List<Job>> getPastJobsAppliedByUid(String workerUid) async{
    QuerySnapshot<Map<String,dynamic>> jobsSnap = await _db.collection("jobs").where("approvedWorkers",arrayContains: workerUid).get();
    return filterJobs(jobsSnap, "past");
  }

  /*
  Get all the jobs the user with this uid is approved in
   */
  Future<List<Job>> getFutureJobsAppliedByUid(String workerUid) async{
    QuerySnapshot<Map<String,dynamic>> jobsSnap = await _db.collection("jobs").where("approvedWorkers",arrayContains: workerUid).get();
    return filterJobs(jobsSnap, "future");
  }

  Future<List<Job>> getFutureJobsCreatedByUid(String employerUid) async{
    QuerySnapshot<Map<String,dynamic>> jobsSnap = await _db.collection("jobs").where("employerUid",isEqualTo:employerUid ).get();
    return filterJobs(jobsSnap, "future");
  }

  Future<List<Job>> getPastJobsCreatedByUid(String employerUid) async{
    QuerySnapshot<Map<String,dynamic>> jobsSnap = await _db.collection("jobs").where("employerUid",isEqualTo:employerUid ).get();
    return filterJobs(jobsSnap, "past");
  }

  /*
   * get all the approval jobs of a worker (past and future)
  */
  Future<List<Job>> getAllWorkerApprovalJobs(String workerUid) async{
    List<Job> past = await getPastJobsAppliedByUid(workerUid);
    List<Job> future = await getFutureJobsAppliedByUid(workerUid);
    past.addAll(future);
    return past;
  }

  /*
  Get all reviews written on UID
   */
  Future<List<JobReview>> getReviewsOnUid(String uid) async{
    QuerySnapshot<Map<String,dynamic>> reviewsSnap = await _db.collection("reviews").where("receiver",isEqualTo: uid).get();
    List<JobReview> reviews = [];
    for(var review in reviewsSnap.docs)
      {
        reviews.add(JobReview.fromMap(review.data()));
      }
    return reviews;
  }

  /*
  Add review to database
   */
  Future<void> createReview(JobReview review) async{
    await _db.collection("reviews").add(review.toMap());
  }
}
