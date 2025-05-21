//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/utils/user_preferences.dart';
import 'package:lab1/widget/appbar_widget.dart';
import 'package:lab1/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(imagePath: user.imagePath, onClicked: () async {}),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),

        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(user.email, style: const TextStyle(color: Colors.grey)),
    ],
  );

  
}
