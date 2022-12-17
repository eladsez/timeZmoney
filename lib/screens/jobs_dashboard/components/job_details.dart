import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../../business_Logic/models/Job.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key, required this.job});

  final Job job;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.45,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1.6,
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(20),
                    title: Text(
                      widget.job.title.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.8),
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.white12],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height + 200));
                      },
                      blendMode: BlendMode.dst,
                      child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.job.imageUrl)),
                    ),
                  ),
                )
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.job.district,
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.job.description,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  )
                ],
              ),
            ),
          )),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FloatingActionButton.extended(
          onPressed: () {}, // TODO: add map logic and screen
          icon: const Icon(Icons.directions),
          label: const Text("Directions"),
          backgroundColor: const Color(0xff01b2b8),
        )
      ],
    );
  }
}
