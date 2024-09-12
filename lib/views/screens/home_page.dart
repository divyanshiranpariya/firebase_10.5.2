import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';
import '../../utils/firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.fetchUser(),
        builder: (context, ss) {
          if (ss.hasError) {
            return Center(
              child: Text("ERROR: ${ss.error}"),
            );
          } else if (ss.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = ss.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allData =
                (data == null) ? [] : data.docs;
            return ListView.separated(
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("${i + 1}"),
                      ),
                      title: (AuthHelper.firebaseAuth.currentUser!.email ==
                              allData[i].data()['email'])
                          ? Text(" you ${allData[i].data()['email']}")
                          : Text("${allData[i].data()['email']}"),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
              itemCount: allData.length,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
