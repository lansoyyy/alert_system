import 'package:alert_system/screens/auth/login_screen.dart';
import 'package:alert_system/screens/profile_screen.dart';
import 'package:alert_system/utils/const.dart';
import 'package:alert_system/widgets/logout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alert_system/widgets/text_widget.dart';

import '../utils/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 250,
      color: Colors.grey[100],
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: primary,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                                color: Colors.white),
                            child: Center(
                              child: TextWidget(
                                text: data['name'][0],
                                fontSize: 32,
                                color: primary,
                                fontFamily: 'Bold',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          TextWidget(
                            text: data['name'],
                            fontFamily: 'Bold',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Icon(Icons.edit_square),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileTab(),
                      ),
                    );
                  },
                  title: TextWidget(
                    text: 'Edit Profile',
                    fontSize: 14,
                    fontFamily: 'Bold',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    logout(context, const LoginScreen());
                  },
                  title: TextWidget(
                    text: 'Logout',
                    fontSize: 14,
                    fontFamily: 'Bold',
                  ),
                ),
              ],
            );
          }),
    );
  }
}
