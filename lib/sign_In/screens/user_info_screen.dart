// ignore_for_file: deprecated_member_use

import 'package:agrodoctor/doctor/TfliteModel.dart';
import 'package:agrodoctor/sign_In/res/custom_colors.dart';
import 'package:agrodoctor/sign_In/screens/sign_in_screen.dart';
import 'package:agrodoctor/sign_In/utils/authentication.dart';
import 'package:agrodoctor/sign_In/widgets/app_bar_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  "https://images.unsplash.com/photo-1560493676-04071c5f467b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80"
      "https://media.istockphoto.com/photos/shot-of-a-young-woman-using-a-digital-tablet-while-inspecting-crops-picture-id1365693929?s=612x612"
      "https://media.istockphoto.com/photos/man-in-a-coffee-plantation-researcher-picture-id1338114224?s=612x612"
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 2.0),
              Text(
                _user.displayName!,
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 5,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 5,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                style: TextStyle(
                    color: CustomColors.firebaseGrey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 16.0),
              _isSigningOut
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context)
                            .pushReplacement(_routeToSignInScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 3,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitle(),
      ),
      drawer: Drawer(
        child: Container(
            color: Color.fromARGB(255, 254, 254, 255),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Row(),
                const SizedBox(
                  height: 30,
                ),
                _user.photoURL != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          _user.photoURL!,
                        ),
                        radius: 30,
                      )
                    : CircleAvatar(
                        child: Material(
                          color: CustomColors.firebaseGrey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: CustomColors.firebaseGrey,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 8.0),
                Text(
                  _user.displayName!,
                  style: TextStyle(
                    color: CustomColors.firebaseYellow,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '( ${_user.email!} )',
                  style: TextStyle(
                    color: CustomColors.firebaseOrange,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                  style: TextStyle(
                      color: CustomColors.firebaseGrey.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 0.2),
                ),
                const SizedBox(height: 16.0),
                _isSigningOut
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.redAccent,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });
                          await Authentication.signOut(context: context);
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context)
                              .pushReplacement(_routeToSignInScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Powerd by",
                  textAlign: TextAlign.center,
                ),
                Center(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/firebase_logo.png',
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Agro',
                      style: TextStyle(
                        color: CustomColors.firebaseYellow,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      ' Doctor',
                      style: TextStyle(
                        color: CustomColors.firebaseOrange,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ))
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 1,
              ),
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 113,
                      height: 100,
                      child: Card(
                          child: ListView(
                        children: const [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.calculate_rounded,
                              size: 30.0,
                            ),
                          ),
                          Text("Fertilizer Calculator")
                        ],
                      )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 113,
                      height: 100,
                      child: Card(
                          child: ListView(
                        children: const [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.bug_report_rounded,
                              size: 30.0,
                            ),
                          ),
                          Text("Pests & diseases"),
                        ],
                      )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 113,
                      height: 100,
                      child: Card(
                          child: ListView(
                        children: const [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.compost_rounded,
                              size: 30.0,
                            ),
                          ),
                          Text("Cultivation        Tips")
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              Row(),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '  Heal Your Crop',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/homescreen/docbar.png',
                          width: 300,
                        ),
                      ],
                    ),
                    FlatButton(
                      minWidth: 300,
                      color: Color.fromARGB(255, 15, 76, 180),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TfliteModel()),
                        );
                      },
                      child: const Text('Take a picture'),
                    ),
                  ],
                ),
                elevation: 8,
                shadowColor: Colors.green,
                margin: EdgeInsets.all(20),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item,
                      fit: BoxFit.cover, width: double.infinity),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ],
              )),
        ))
    .toList();
