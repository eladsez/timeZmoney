import '../../data_access/firestore_dal.dart';
import '../models/CustomUser.dart';
import '../models/Job.dart';
import 'auth_actions.dart';

class JobsActions {
  final DataAccessService das = DataAccessService();
  static List<String> majors = [];
  static int selectedMajorIndex = 0;

  /*
   * This function is called whenever user change the current major tabs
   * in the jobs dashboard screen
   * It will return the jobs of the current selected tab (selected major)
   */
  Future<List<Job>> getJobsOfTab(String majorTab) async {
    if (majorTab == "For You") {
      return await das.getAllJobs();
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
   * get a list of CustomUser from a list of uid
   */
  Future<List<CustomUser>> getUsersFromUid(List<dynamic> uids) async {
    List<CustomUser> users = [];
    for (String uid in uids) {
      CustomUser? user = await das.getCustomUserByUid(uid);
      if (user != null) {
        users.add(user);
      }
    }
    return users;

    void uploadJobImage() {}
  }

  Future<void> addUserToWaitList(Job job) async {
    await das.addWorkerToWaitList(job,AuthActions.currUser.uid);
  }
/*
  * hire a worker for a job
 */
  void hireWorker(Job job, String? user_uid) {
    // TODO: implement hireWorker
    // job.signedWorkers.add(user_uid);
    // das.updateJob(job);
  }
}
