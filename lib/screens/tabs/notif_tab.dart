import 'package:alert_system/utils/colors.dart';
import 'package:alert_system/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class NotifTab extends StatelessWidget {
  const NotifTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: primary,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Content of Notifiactions',
                      fontSize: 18,
                    ),
                    TextWidget(
                      text: 'Date and Time',
                      fontSize: 12,
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 10,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
