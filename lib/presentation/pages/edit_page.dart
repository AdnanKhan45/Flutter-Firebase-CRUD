
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud/data/models/user_model.dart';
import 'package:flutter_firebase_crud/data/remote_data_source/firestore_helper.dart';

class EditPage extends StatefulWidget {
  final UserModel user;
  const EditPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? _usernameController;
  TextEditingController? _ageController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.username);
    _ageController = TextEditingController(text: widget.user.age);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    _ageController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit"),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
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
                  FirestoreHelper.update(UserModel(id: widget.user.id, username: _usernameController!.text, age: _ageController!.text),).then((value) {
                    Navigator.pop(context);
                  });
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
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
