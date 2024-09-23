import 'package:alert_system/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnnouncementTab extends StatelessWidget {
  bool? inAdmin;

  AnnouncementTab({
    super.key,
    this.inAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Announcement').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Container(
              child: ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the Announcement Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementDetailPage(
                            title: data.docs[index]['name'],
                            subtitle: '',
                            imagePath: data.docs[index]['image'],
                            details: data.docs[index]['desc'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Announcement Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.network(
                              data.docs[index]['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Announcement Title
                                inAdmin!
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: data.docs[index]['name'],
                                            fontSize: 20,
                                            isBold: true,
                                            color: Colors.black,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                          'Delete Confirmation',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'QBold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: const Text(
                                                          'Are you sure you want to delete this announcement?',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'QRegular'),
                                                        ),
                                                        actions: <Widget>[
                                                          MaterialButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                            child: const Text(
                                                              'Close',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'QRegular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Announcement')
                                                                  .doc(data
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Continue',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'QRegular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    : TextWidget(
                                        text: data.docs[index]['name'],
                                        fontSize: 20,
                                        isBold: true,
                                        color: Colors.black,
                                      ),
                                const SizedBox(height: 8),
                                // Announcement Subtitle
                                TextWidget(
                                  text: data.docs[index]['desc'],
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}

class AnnouncementDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String details;

  const AnnouncementDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Details'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Announcement Image
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imagePath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Announcement Title
              TextWidget(
                text: title,
                fontSize: 28,
                isBold: true,
                color: Colors.black,
              ),

              const SizedBox(height: 16),
              // Announcement Details
              TextWidget(
                text: details,
                fontSize: 16,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
