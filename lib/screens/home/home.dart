import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../data_access/dal.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dal dal = Dal();
  @override
  Widget build(BuildContext context) {

    return Column(children:[
      const Text("Home"),
      Container(child: StreamBuilder<QuerySnapshot>(
          stream: dal.users,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('somthing whent worng');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('loading');
            }
            final data = snapshot.requireData;
            return Text('${data.docs[0]['Username']}');
          },

      ),),
    ],);
  }
}
