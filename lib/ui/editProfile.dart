import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_india/services/colors.dart';
import 'home.dart';
import 'package:quiz_india/models/user.dart';
import 'package:flutter/material.dart' hide Action;

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
    });
    if (_displayNameValid) {
      usersRef.document(widget.currentUserId).updateData({
        "displayName": displayNameController.text,
      });
      SnackBar snackbar = SnackBar(
        content: Text("Profile Updated"),
        backgroundColor: primaryColor,
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        CustomPaint(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
//                            height: MediaQuery.of(context).size.height,
                          ),
                          painter: HeaderCurvedContainer(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 4),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Column(
                              children: <Widget>[
                                Container(
//                        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(user !=
                                              null
                                          ? user.photoUrl
                                          : "https://cdn.iconscout.com/icon/free/png-256/user-1648810-1401302.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildDisplayNameField(),
                        ],
                      ),
                    ),
                    FloatingActionButton.extended(
                      onPressed: updateProfileData,
                      label: Text(
                        "Update Profile",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      backgroundColor: darkAccentColor,
                    ),
//                    RaisedButton(
//                      onPressed: updateProfileData,
//                      child: Text(
//                        "Update Profile",
//                        style: TextStyle(
//                          color: primaryColor,
//                          fontSize: 20.0,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = primaryColor;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
