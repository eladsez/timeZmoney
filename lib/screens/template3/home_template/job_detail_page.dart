import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/images.dart';

class JobDetailPage extends StatefulWidget {
  const  JobDetailPage({required Key key}) : super(key: key);

  // static Route<T> getJobDetail<T>() {
  //   return MaterialPageRoute(
  //     builder: (_) => const JobDetailPage(key: null,),
  //   );
  // }

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(Images.gitlab, height: 40),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Gitlab",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KColors.title,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "UX Designer",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: KColors.subtitle,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _headerStatic("Salary", "\$85,000"),
              _headerStatic("Applicants", "45"),
              _headerStatic("Salary", "\$120,000"),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child:
                    Image.asset(Images.doc, height: 20, color: KColors.primary),
              ),
              Expanded(
                child:
                    Image.asset(Images.museum, height: 20, color: KColors.icon),
              ),
              Expanded(
                child:
                    Image.asset(Images.clock, height: 20, color: KColors.icon),
              ),
              Expanded(
                child: Image.asset(Images.map, height: 20, color: KColors.icon),
              ),
            ],
          ),
          const Divider(
            color: KColors.icon,
            height: 25,
          )
        ],
      ),
    );
  }

  Widget _headerStatic(String title, String sub) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: KColors.subtitle,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: KColors.title,
            ),
          )
        ],
      ),
    );
  }

  Widget _jobDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Job Description",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "You will be Gitlab's dedicated UI/Ux designer, reporting to the chief Technology Officer. You will come up with the user experience for few product features, including developing conceptual design to test with clients and then. Share the...",
            style: TextStyle(fontSize: 14, color: KColors.subtitle),
          ),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            child: const Text("Learn more",
                style: TextStyle(fontSize: 14, color: KColors.primary)),
          )
        ],
      ),
    );
  }

  Widget _ourPeople(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.only(left: 16),
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Our People",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _people(context, img: Images.user1, name: "J. Smith"),
                _people(context, img: Images.user2, name: "L. James"),
                _people(context, img: Images.user3, name: "Emma"),
                _people(context, img: Images.user4, name: "Mattews"),
                _people(context, img: Images.user5, name: "Timothy"),
                _people(context, img: Images.user6, name: "Kyole"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _people(BuildContext context, {required String img, required String name}) {
    return Container(
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(img),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 10, color: KColors.subtitle)),
        ],
      ),
    );
  }

  Widget _apply(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 54),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(KColors.primary),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16))),
              onPressed: () {},
              child: const Text(
                "Apply Now",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 50,
            width: 60,
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  const BorderSide(color: KColors.primary),
                ),
              ),
              child: const Icon(
                Icons.bookmark_border,
                color: KColors.primary,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColors.background,
        iconTheme: const IconThemeData(color: KColors.primary),
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.cloud_upload_outlined), onPressed: () {})
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _jobDescription(context),
          _ourPeople(context),
          _apply(context)
        ],
      ),
    );
  }
}
