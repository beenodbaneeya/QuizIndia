import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/models/user.dart';
import 'package:quiz_india/ui/weeklyquiz.dart';
import 'package:quiz_india/widgets/widgets.dart';
import 'aboutus.dart';
import 'editProfile.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;
  ProfilePage({this.profileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserID = currentUser?.id;
  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Transform.scale(
            child: CircularProgressIndicator(),
            scale: 0.125,
          );
        }
        User user = User.fromDocument(snapshot.data);
        return Stack(
          children: <Widget>[
            CustomPaint(
              child: Container(
                width: MediaQuery.of(context).size.width,
              ),
              painter: HeaderCurvedContainer(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.username == null ? "" : user.username,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: darkAccentColor),
                    ),
                    Text(
                      user.displayName,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: primaryColor,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildProfileHeader(),
              Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfile(
                                currentUserId: currentUserID,
                              )));
                    },
                    leading: Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                    title: Text("Edit Profile"),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WeeklyQuiz()));
                    },
                    leading: Icon(Icons.star, color: primaryColor),
                    title: Text("Weekly Quiz"),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                    leading: Icon(Icons.account_box, color: primaryColor),
                    title: Text("About"),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      logout();
                    },
                    leading: Icon(Icons.exit_to_app, color: primaryColor),
                    title: Text("Logout"),
                  ),
                ],
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
