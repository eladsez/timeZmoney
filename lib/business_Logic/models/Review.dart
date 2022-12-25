/*
This class represents a single job review
called JobReview and not just Review because of a google package
 */
class JobReview {
  int stars;
  String writer;
  String receiver;
  String work;
  String content;


  JobReview(
      {required this.stars,
        required this.writer,
        required this.work,
        required this.content,
        required this.receiver,
        });

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "stars": stars,
      "work": work,
      "receiver": receiver,
      "writer": writer,
    };
  }

  static JobReview fromMap(Map<String, dynamic> review) {
    return JobReview(
     stars: review['stars'],
      work: review['work'],
      receiver: review['receiver'],
      writer: review['writer'],
      content: review['content']
    );
  }
}
