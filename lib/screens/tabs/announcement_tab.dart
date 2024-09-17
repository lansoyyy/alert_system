import 'package:alert_system/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AnnouncementTab extends StatelessWidget {
  const AnnouncementTab({super.key});

  final List<Map<String, String>> announcements = const [
    {
      'title': 'Urgent System Outage!',
      'subtitle': 'Our services are currently down due to an unexpected issue.',
      'imagePath': 'https://via.placeholder.com/150',
      'details': 'We are working hard to restore services as quickly as possible. '
          'Please stay tuned for further updates. We apologize for the inconvenience caused.'
    },
    {
      'title': 'Critical Security Update!',
      'subtitle':
          'Please update your software immediately to avoid vulnerabilities.',
      'imagePath': 'https://via.placeholder.com/150',
      'details':
          'A major security vulnerability has been discovered. Please ensure that '
              'your software is up-to-date to avoid potential threats. Update now in the settings.'
    },
    {
      'title': 'Scheduled Maintenance Alert',
      'subtitle': 'We will be undergoing scheduled maintenance soon.',
      'imagePath': 'https://via.placeholder.com/150',
      'details':
          'Our systems will be undergoing maintenance on the 20th from 1:00 AM to 3:00 AM. '
              'During this time, some services may be unavailable. Thank you for your patience.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the Announcement Detail Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementDetailPage(
                      title: announcement['title']!,
                      subtitle: announcement['subtitle']!,
                      imagePath: announcement['imagePath']!,
                      details: announcement['details']!,
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        announcement['imagePath']!,
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
                          TextWidget(
                            text: announcement['title']!,
                            fontSize: 20,
                            isBold: true,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8),
                          // Announcement Subtitle
                          TextWidget(
                            text: announcement['subtitle']!,
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
      ),
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
              const SizedBox(height: 10),
              // Announcement Subtitle
              TextWidget(
                text: subtitle,
                fontSize: 18,
                color: Colors.grey,
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
