import 'package:alert_system/screens/auth/login_screen.dart';
import 'package:alert_system/screens/tabs/announcement_tab.dart';
import 'package:alert_system/screens/tabs/evacuation_tab.dart';
import 'package:alert_system/screens/tabs/notif_tab.dart';
import 'package:alert_system/screens/tabs/weather_tab.dart';
import 'package:alert_system/widgets/drawer_widget.dart';
import 'package:alert_system/widgets/logout_widget.dart';
import 'package:alert_system/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AnnouncementTab(),
    const WeatherTab(),
    const NotifTab(),
    const EvacuationTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List labels = [
    'Announcement',
    'Weather',
    'Notifications',
    'Evacuation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        centerTitle: true,
        title: TextWidget(
          text: labels[_selectedIndex],
          fontSize: 18,
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.info_outline),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: TextWidget(
                    text: 'DDRMO: 09776825025',
                    fontSize: 18,
                    fontFamily: 'Bold',
                    color: Colors.red,
                  ),
                ),
                PopupMenuItem(
                  child: TextWidget(
                    text: 'PNP: 09159231598',
                    fontSize: 18,
                    fontFamily: 'Bold',
                    color: Colors.red,
                  ),
                ),
                PopupMenuItem(
                  child: TextWidget(
                    text: 'BFP: 09311818435',
                    fontSize: 18,
                    fontFamily: 'Bold',
                    color: Colors.red,
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_queue),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'Evacuation',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
