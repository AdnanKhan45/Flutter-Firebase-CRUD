import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud/data/models/user_model.dart';
import 'package:flutter_firebase_crud/data/remote_data_source/firestore_helper.dart';
import 'package:flutter_firebase_crud/presentation/pages/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Firebase Create"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "username"),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "age"),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.create(UserModel(username: _usernameController.text, age: _ageController.text));
                  // _create();
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.read(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: userData!.length,
                            itemBuilder: (context, index) {
                              final singleUser = userData[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  onLongPress: () {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content: Text("are you sure you want to delete"),
                                        actions: [
                                          ElevatedButton(onPressed: () {
                                            FirestoreHelper.delete(singleUser).then((value) {
                                              Navigator.pop(context);
                                            });
                                          }, child: Text("Delete"))
                                        ],
                                      );
                                    });
                                  },
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                                  ),
                                  title: Text("${singleUser.username}"),
                                  subtitle: Text("${singleUser.age}"),
                                  trailing: InkWell(onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(user: UserModel(username: singleUser.username, age: singleUser.age, id: singleUser.id),)));
                                  },child: Icon(Icons.edit)),
                                ),
                              );
                            }),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

// Future _create() async {
//   final userCollection = FirebaseFirestore.instance.collection("users");
//
//   final docRef = userCollection.doc();
//
//   await docRef.set({
//     "username": _usernameController.text,
//     "age": _ageController.text
//   });
//
//
// }
}
