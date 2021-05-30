import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_india/authenticate/backgroundpainter.dart';
import 'package:quiz_india/authenticate/title.dart';
import 'package:quiz_india/services/colors.dart';
import 'package:quiz_india/ui/profilepage.dart';
import 'package:quiz_india/ui/searchsearch.dart';
import 'package:quiz_india/ui/homepage.dart';
import 'package:quiz_india/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_account.dart';
import 'homepage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final quizRef = Firestore.instance.collection('Quizes');
final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool isAuth = true;
  PageController pageController;
  int pageIndex = 0;
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
    pageController = PageController();
    //Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        handleSignIn(account);
      } else {
        setState(() {});
      }
    }, onError: (err) {
      print('Error signing in : $err');
    });
    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in : $err');
      setState(() {
        isAuth = false;
      });
    });
  }

  handleSignIn(GoogleSignInAccount account) {
//    _loading = true;
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    //1) check if user exists in users collection in database(according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();
    // 2)if the user doesn't  exist ,then we want to take them to the create account page

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      // 3) get username from create account,use it to make new user document in user's collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp,
      });
      doc = await usersRef.document(user.id).get();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", user.id);

    currentUser = User.fromDocument(doc);
//    print(currentUser);
//    print(currentUser.username);
  }

  @override
  void dispose() {
    pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          HomePage(),
          CloudFirestoreSearch(),
          ProfilePage(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(animation: _controller.view),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: LoginTitle(
                          title: 'QuizIndia',
                        )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(54.0),
                      child: GestureDetector(
                        onTap: login,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/google_signin_button1.png'),
//                            fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Please connect to the internet to play the quiz....",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: darkAccentColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
