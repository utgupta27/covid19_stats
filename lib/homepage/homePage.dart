import 'package:covid19_stats/cases/casePage.dart';
import 'package:covid19_stats/overview/overviewPage.dart';
import 'package:covid19_stats/vaccination/vacinationPage.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

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
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: new BottomNavyBar(
        items: [
          BottomNavyBarItem(
              icon: FittedBox(
                child: Image.asset('assets/corona.png'),
                fit: BoxFit.fill,
              ),
              title: Text(
                "  Overview",
              ),
              activeColor: Colors.redAccent),
          BottomNavyBarItem(
              icon: FittedBox(
                child: Image.asset('assets/graph.png'),
                fit: BoxFit.fill,
              ),
              title: Text("  Cases"),
              activeColor: Colors.blueAccent),
          BottomNavyBarItem(
              icon: FittedBox(
                child: Image.asset('assets/syringe.png'),
                fit: BoxFit.fill,
              ),
              title: Text(
                "  Vaccine",
                style: TextStyle(color: Colors.blue[900]),
              ),
              activeColor: Colors.lightBlue)
        ],
        selectedIndex: _currentIndex,
        onItemSelected: onItemTapped,
      ),
    );
  }
}
