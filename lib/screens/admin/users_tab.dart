import 'package:alert_system/widgets/text_widget.dart';
import 'package:alert_system/widgets/toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('isVerified', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            );
          }

          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: SizedBox(
                    width: 350,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 75,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: data.docs[index]['name'],
                              fontSize: 18,
                              fontFamily: 'Bold',
                            ),
                            TextWidget(
                              text: data.docs[index]['email'],
                              fontSize: 14,
                              fontFamily: 'Regular',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const Expanded(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(data.docs[index].id)
                                .update({
                              'isVerified': true,
                            });
                            showToast('User verified!');
                          },
                          icon: const Icon(
                            Icons.verified,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
