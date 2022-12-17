import '../../data_access/firestore_dal.dart';
import '../models/Job.dart';

class JobsActions {
  final DataAccessService das = DataAccessService();
  static List<String> majors = [];
  static int selectedMajorIndex = 0;

  Future<List<Job>> getJobsOfTab(String majorTab) async{
    if (majorTab == "For You"){
      return await das.getAllJobs();
    }
    return das.getJobsOfMajor(majorTab);
  }

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
