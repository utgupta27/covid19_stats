import 'package:covid19_stats/cases/casePage.dart';
import 'package:covid19_stats/overview/overviewPage.dart';
import 'package:covid19_stats/vaccination/vacinationPage.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [OverviewPage(), CasePage(), VaccinationPage()];

  void onItemTapped(int val) {
    setState(() {
      _currentIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 Statistics"),
        backgroundColor: Colors.blue[900],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: new BottomNavyBar(
        // backgroundColor: Colors.grey,
        items: [
          BottomNavyBarItem(
              icon: Icon(FontAwesome5.viruses),
              title: Text(
                "  Overview",
              ),
              activeColor: Colors.redAccent),
          BottomNavyBarItem(
              icon: Icon(FontAwesome5.chart_line),
              title: Text("  Cases"),
              activeColor: Colors.blueAccent),
          BottomNavyBarItem(
              icon: Icon(FontAwesome5.syringe),
              title: Text(
                "  Vaccine",
              ),
              activeColor: Colors.lightBlue)
        ],
        selectedIndex: _currentIndex,
        onItemSelected: onItemTapped,
      ),
    );
  }
}
