import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_z_money/business_Logic/actions/storage_actions.dart';
import 'package:time_z_money/data_access/server_dal.dart';
import '../../data_access/firestore_dal.dart';
import '../../screens/scheduler/components/neat_and_clean_calendar_event.dart';
import '../models/CustomUser.dart';
import '../models/Job.dart';
import 'auth_actions.dart';

class JobsActions {

  final DataAccessService das = DataAccessService();
  dynamic server = DataAccessService();
  final StorageActions storageActions = StorageActions();
  static List<String> majors = [];
  static int selectedMajorIndex = 0;

  /*
   * This function is called whenever user change the current major tabs
   * in the jobs dashboard screen
   * It will return the jobs of the current selected tab (selected major)
   */
  Future<List<Job>> getJobsOfTab(String majorTab) async {
    if (majorTab == "For You") {
      return await server.getAllRelevantJobs();
    }
    return server.getJobsOfMajor(majorTab);
  }

  Future<List<Job>> getAllJobs() async {
    return await server.getAllRelevantJobs();
  }

  /*
   * get the available majors from the jobsMajors collection
   * The "For You" major always will be the first
   */
  Future<List<String>> getJobsMajors() async {
    if (majors.isEmpty) {
      majors = await server.getMajors();
      majors.remove("For You");
      majors.insert(0, "For You");
    }
    return majors;
  }

  /*
   * function to retrieve all the jobs of the current employer
   */
  Future<List<Job>> getEmployerJobs() async {
    return await server.getJobsOfEmployer(AuthActions.currUser.uid);
  }

  /*
   * get job by uid
   */
  Future<Job?> getJobByUid(String jobUid) async {
    return await server.getJobByUid(jobUid);
  }

  Future<void> addUserToWaitList(Job job) async {
    await server.addWorkerToWaitList(job, AuthActions.currUser.uid);
    job.signedWorkers.add(AuthActions.currUser.uid);
  }

/*
  * approve a worker for a job
  * warning: it doesn't check if the amount needed for the job is already full
 */
  Future<void> approveUserToJob(Job job, String? workerUid) async {
    await das.approveWorker(job, workerUid!);
  }

  /*
   * remove a worker from a job
   */
  Future<void> removeUserFromJob(Job job, String? workerUid) async {
    await das.removeWorker(job, workerUid!);
  }

  Future<String> chooseUploadJobImage(String jobTitle) async {
    return await storageActions.uploadImage(
        "jobsImages/$jobTitle"); // TODO: change the remote image name to something more unique
  }

  Future<void> postJob(Job nowJob) async {
    await das.createJob(nowJob);
  }

  /*
  Get all the jobs the current user did
   */
  Future<List<Job>> getPastJobsApproved(CustomUser user) async {
    return await das.getPastJobsAppliedByUid(user.uid!);
  }

  /*
  Get all the jobs the current user is approved for
   */
  Future<List<Job>> getFutureJobsApproved(CustomUser user) async {
    return await das.getFutureJobsAppliedByUid(user.uid!);
  }

  /*
  Get all future jobs created by the current user
   */
  Future<List<Job>> getFutureJobsCreated(CustomUser user) async {
    return await das.getFutureJobsCreatedByUid(user.uid!);
  }

  /*
  Get all future jobs created by the current user
   */
  Future<List<Job>> getPastJobsCreated(CustomUser user) async {
    return await das.getPastJobsCreatedByUid(user.uid!);
  }

  Future<List<Job>> getCoOperateJobs(CustomUser operateUser) async {
    return await das.getCoOperateJobs(AuthActions.currUser, operateUser);
  }

  updateUnseenToSeen(Job job) async {
    await das.updateUnseenToSeen(job, AuthActions.currUser.uid!);
  }

  Future<List<Job>> getRelevantJobsByTitle(String title) async{
    List<Job> jobs = await das.getAllRelevantJobs();
    jobs.removeWhere((job) {
      return !job.title.toLowerCase().startsWith(title.toLowerCase());
    });

    // jobs.sort((a ,b) {return a.title.toLowerCase().compareTo(b.title.toLowerCase());});
    return jobs;
  }

  Future<List<NeatCleanCalendarEvent>> getCurrUserEvent() async {
    List<Job> jobs = AuthActions.currUser.userType == "worker"
        ? await das.getAllWorkerApprovalJobs(AuthActions.currUser.uid!)
        : await das.getJobsOfEmployer(AuthActions.currUser.uid!);

    return jobs
        .map((job) => NeatCleanCalendarEvent(job.title,
            description: job.district,
            startTime: job.date.toDate(),
            endTime: job.date.toDate()))
        .toList();
  }
}
