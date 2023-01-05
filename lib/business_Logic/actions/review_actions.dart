
import '../../business_Logic/models/Review.dart';
import '../../data_access/firestore_dal.dart';
import '../models/CustomUser.dart';

/*
This class is made to handle everything that is connected to the reviews collection in the database
 */
class ReviewActions{
  final DataAccessService das = DataAccessService();

  Future<List<JobReview>> getReviewsOnUser(CustomUser user) async{
    return das.getReviewsOnUid(user.uid!);
  }

  Future<void> postReview(JobReview review) async {
    das.createReview(review);
  }
}