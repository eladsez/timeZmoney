import 'package:time_z_money/business_Logic/actions/storage_actions.dart';
import '../../data_access/firestore_dal.dart';
import '../models/CustomUser.dart';
import '../models/Job.dart';
import 'auth_actions.dart';

class JobsActions {
  final DataAccessService das = DataAccessService();
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
      return await das.getAllRelevantJobs();
    }
    return das.getJobsOfMajor(majorTab);
  }

  /*
   * get the available majors from the jobsMajors collection
   * The "For You" major always will be the first
   */
  Future<List<String>> getJobsMajors() async {
    if (majors.isEmpty) {
      majors = await das.getMajors();
      majors.remove("For You");
      majors.insert(0, "For You");
    }
    return majors;
  }

  /*
   * function to retrieve all the jobs of the current employer
   */
  Future<List<Job>> getEmployerJobs() async {
    return await das.getJobsOfEmployer(AuthActions.currUser.uid);
  }

  /*
   * get job by uid
   */
  Future<Job?> getJobByUid(String jobUid) async {
    return await das.getJobByUid(jobUid);
  }




  Future<void> addUserToWaitList(Job job) async {
    await das.addWorkerToWaitList(job,AuthActions.currUser.uid);
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
  
  Future<String> chooseUploadJobImage(String jobTitle) async{
    return await storageActions.uploadImage("jobsImages/$jobTitle"); // TODO: change the remote image name to something more unique
  }

  Future<void> postJob(Job nowJob) async{
    await das.createJob(nowJob);
  }

  /*
  Get all the jobs the current user did
   */
  Future<List<Job>> getPastJobs() async{
    return await das.getPastJobsByUid(AuthActions.currUser.uid);
  }

  /*
  Get all the jobs the current user is approved for
   */
  Future<List<Job>> getFutureJobs() async{
    return await das.getFutureJobsByUid(AuthActions.currUser.uid);
  }


}
