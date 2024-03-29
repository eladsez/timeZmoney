import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import 'package:time_z_money/screens/Authenticate/components/profile_chooser.dart';
import '../business_Logic/models/CustomUser.dart';
import '../business_Logic/models/Review.dart';

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

    if (snapshot.docs.isNotEmpty) {
      return CustomUser.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  /*
   * Get a CustomUser by his uid
   */
  Future<CustomUser?> getCustomUserByUid(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").where('uid', isEqualTo: uid).get();
    if (snapshot.docs.isEmpty) {
      //TODO: commentted out the print statement because it was printing too much
      // print("User doesn't exist yet\n");
    } else if (snapshot.docs.isNotEmpty) {
      return CustomUser.fromMap(snapshot.docs.first.data());
    }
    return null;
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

  Future<List<Job>> getRelevantJobsByFiled(String filed, dynamic equalTo) async{
    QuerySnapshot<Map<String, dynamic>> jobsSnapshot =
        await _db.collection("jobs").where(filed, isGreaterThanOrEqualTo: equalTo).get();

    return filterRelevantJobs(jobsSnapshot);
  }

  /*
   * This function return list of string
   * the list contain the job majors available in the database
   * used to display the majors tabs
   */
  Future<List<String>> getMajors() async {
    QuerySnapshot<Map<String, dynamic>> majorsSnapshot =
        await _db.collection("jobsMajors").get();
    return majorsSnapshot.docs
        .map((doc) => doc.data()["major"].toString())
        .toList();
  }

  /*
   * Get the jobs the employerUid post
   */
  Future<List<Job>> getJobsOfEmployer(String employerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap = await _db
        .collection("jobs")
        .where("employerUid", isEqualTo: employerUid)
        .get();
    return jobsSnap.docs.map((doc) => Job.fromMap(doc.data())).toList();
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

  /*
  Filter jobs according to type(future or past)
   */
  List<Job> filterJobs(
      QuerySnapshot<Map<String, dynamic>> jobsSnap, String type) {
    List<Job> jobs = type.compareTo("future") == 0
        ? jobsSnap.docs
            .map((snap) => Job.fromMap(snap.data()))
            .where((element) => element.date.compareTo(Timestamp.now()) > 0)
            .toList()
        : jobsSnap.docs
            .map((snap) => Job.fromMap(snap.data()))
            .where((element) => element.date.compareTo(Timestamp.now()) < 0)
            .toList();
    return jobs;
  }

  /*
   * get all relevant jobs in the job collection (for you major)
   * currently relevant jobs are that its date has not passed and there is still place to insert more workers
   */
  Future<List<Job>> getAllRelevantJobs() async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
        await _db.collection("jobs").get();

    return filterRelevantJobs(jobsSnap);
  }

  /*
   * This function get as an argument major of a job and return all the jobs under this major
   */
  Future<List<Job>> getJobsOfMajor(String major) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
        await _db.collection("jobs").where("major", isEqualTo: major).get();
    return filterRelevantJobs(jobsSnap);
  }

  Future<void> addWorkerToWaitList(Job job, String uid) async {
    await _db.collection("jobs").doc(job.uid).update({
      "signedWorkers": FieldValue.arrayUnion([uid])
    });
  }

  Future<void> approveWorker(Job job, String workerUid) async {
    _db.collection("jobs").doc(job.uid).update({
      "signedWorkers": FieldValue.arrayRemove([workerUid]),
      "approvedWorkers": FieldValue.arrayUnion(["$workerUid,unseen"])
    });
    // update the job object
    job.signedWorkers.remove(workerUid);
    job.approvedWorkers.add("$workerUid,unseen");
  }

  Future<void> updateUnseenToSeen(Job job, String workerUid) async {
    _db.collection("jobs").doc(job.uid).update({
      "approvedWorkers": FieldValue.arrayRemove(["$workerUid,unseen"]),
    });
    _db.collection("jobs").doc(job.uid).update({
      "approvedWorkers": FieldValue.arrayUnion(["$workerUid,seen"]),
    });
    // update the job object
    job.approvedWorkers.remove("$workerUid,unseen");
    job.approvedWorkers.add("$workerUid,seen");
  }

  Future<void> removeWorker(Job job, String workerUid) async {
    _db.collection("jobs").doc(job.uid).update({
      "approvedWorkers": FieldValue.arrayRemove(
          ["$workerUid,unseen", "$workerUid,seen", workerUid]),
      "signedWorkers": FieldValue.arrayUnion([workerUid])
    });
    // update the job object
    job.approvedWorkers.remove("$workerUid,unseen");
    job.approvedWorkers.remove("$workerUid,seen");
    job.approvedWorkers.remove(workerUid);
    job.signedWorkers.add(workerUid);
  }

  Future<void> updateJob(String jobUid, String field, dynamic toUpdate) async {
    await _db.collection("jobs").doc(jobUid).update({field: toUpdate});
  }

  /*
  lior don't write it in the server this function is used only for debuting
   */
  Future<void> updateAllJobs(String field, dynamic toUpdate) async {
    await _db.collection("jobs").get().then((snap) => {
          snap.docs.forEach((doc) {
            doc.reference.update({field: toUpdate});
          })
        });
  }

  Future<Job> getJobByUid(String jobUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap =
        await _db.collection("jobs").where("uid", isEqualTo: jobUid).get();
    return Job.fromMap(jobsSnap.docs.first.data());
  }

  /*
  Get all the jobs the worker user with this uid did in the past
   */
  Future<List<Job>> getPastJobsAppliedByUid(String workerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap = await _db
        .collection("jobs")
        .where("approvedWorkers", arrayContainsAny: ["$workerUid,seen", "$workerUid,unseen", workerUid])
        .get();

    return filterJobs(jobsSnap, "past");
  }

  /*
  Get all the jobs the user with this uid is approved in
   */
  Future<List<Job>> getFutureJobsAppliedByUid(String workerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap = await _db
        .collection("jobs")
        .where("approvedWorkers", arrayContainsAny: ["$workerUid,seen", "$workerUid,unseen", workerUid])
        .get();
    return filterJobs(jobsSnap, "future");
  }

  Future<List<Job>> getFutureJobsCreatedByUid(String employerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap = await _db
        .collection("jobs")
        .where("employerUid", isEqualTo: employerUid)
        .get();
    return filterJobs(jobsSnap, "future");
  }

  Future<List<Job>> getPastJobsCreatedByUid(String employerUid) async {
    QuerySnapshot<Map<String, dynamic>> jobsSnap = await _db
        .collection("jobs")
        .where("employerUid", isEqualTo: employerUid)
        .get();
    return filterJobs(jobsSnap, "past");
  }

  /*
   * get all the approval jobs of a worker (past and future)
  */
  Future<List<Job>> getAllWorkerApprovalJobs(String workerUid) async {
    List<Job> past = await getPastJobsAppliedByUid(workerUid);
    List<Job> future = await getFutureJobsAppliedByUid(workerUid);
    past.addAll(future);
    return past;
  }

  Future<List<Job>> getCoOperateJobs(
      CustomUser currUser, CustomUser operateUser) async {
    late QuerySnapshot<Map<String, dynamic>> jobSnap;
    if (currUser.userType == "worker" && operateUser.userType == "employer") {
      jobSnap = await _db
          .collection("jobs")
          .where("employerUid", isEqualTo: operateUser.uid)
          .where("approvedWorkers", arrayContainsAny: [
        "${currUser.uid!},seen",
        "${currUser.uid!},unseen",
      ]).get();
    }

    if (currUser.userType == "employer" && operateUser.userType == "worker") {
      jobSnap = await _db
          .collection("jobs")
          .where("employerUid", isEqualTo: currUser.uid)
          .where("approvedWorkers", arrayContainsAny: [
        "${operateUser.uid!},seen",
        "${operateUser.uid!},unseen",
      ]).get();
    }

    if (currUser.userType == "worker" && operateUser.userType == "worker") {
      jobSnap = await _db
          .collection("jobs")
          .where("approvedWorkers", arrayContainsAny: [
        "${operateUser.uid!},seen",
        "${operateUser.uid!},unseen",
        "${currUser.uid!},seen",
        "${currUser.uid!},unseen",
      ]).get();
    }

    return jobSnap.docs.map((jobDoc) => Job.fromMap(jobDoc.data())).toList();
  }

  /*
  Get all reviews written on UID
   */
  Future<List<JobReview>> getReviewsOnUid(String uid) async {
    QuerySnapshot<Map<String, dynamic>> reviewsSnap =
        await _db.collection("reviews").where("receiver", isEqualTo: uid).get();
    List<JobReview> reviews = [];
    for (var review in reviewsSnap.docs) {
      reviews.add(JobReview.fromMap(review.data()));
    }
    return reviews;
  }

  /*
  Add review to database
   */
  Future<void> createReview(JobReview review) async {
    await _db.collection("reviews").add(review.toMap());
  }
}
