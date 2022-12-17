import '../../data_access/firestore_dal.dart';
import '../models/Job.dart';

class JobsActions {
  final DataAccessService das = DataAccessService();
  static List<String> majors = [];
  static int selectedMajorIndex = 0;

  /*
   * This function is called whenever user change the current major tabs
   * in the jobs dashboard screen
   * It will return the jobs of the current selected tab (selected major)
   */
  Future<List<Job>> getJobsOfTab(String majorTab) async{
    if (majorTab == "For You"){
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

  void uploadJobImage() {}
}
