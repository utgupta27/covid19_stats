import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  static final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int maxNum(confirmed, recovered) {
    int max1 = 0;
    int max2 = 0;
    int maximum = 0;
    for (int i = 0; i < confirmed.length; i++) {
      if (int.parse(confirmed[i].toString()) > max1) {
        max1 = int.parse(confirmed[i].toString());
      }
      if (int.parse(recovered[i].toString()) > max2) {
        max2 = int.parse(recovered[i].toString());
      }
    }
    maximum = max(max1, max2);
    print(maximum);
    return maximum;
  }

  List<double> parseSeries(List<dynamic> data, total) {
    // int value = int.parse(total.toString());
    List<int> parsedData = [];
    for (int i = 0; i < data.length; i++) {
      parsedData.add(data[i]);
    }
    List<double> series = [];
    for (int i = 309; i < parsedData.length; i++) {
      series.add(parsedData[i] / int.parse(total.toString()));
    }
    // print(parsedData[2]);
    return series;
  }

  List<String> getSpaces(List<dynamic> data) {
    int i;
    List<String> space = [];
    for (i = 309; i < data.length; i++) {
      space.add('');
    }
    space[0] = "1 Jan 21";
    space[i - 310] = "Today";
    return space;
  }

  var time = '';
  @override
  void initState() {
    getTime();
    super.initState();
  }

  getTime() async {
    DocumentSnapshot variable = await OverviewPage._firebase
        .collection('countryDailyDelta')
        .doc('lastUpdated')
        .get();
    time =
        "Last Updated: ${DateFormat('dd/MM/yy hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(variable['time'].microsecondsSinceEpoch))}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          children: [
            Text(time.toString()),
            Center(
                child: new StreamBuilder<DocumentSnapshot>(
                    stream: OverviewPage._firebase
                        .collection('countryDailyDelta')
                        .doc('TT')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var info2 = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.red[50],
                          elevation: 5,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Cases Reported in India Today",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Text(
                                  info2['confirmed'].toString(),
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Recovered",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 4),
                                        child: Text(
                                          info2['recovered'].toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Deceased",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 4),
                                        child: Text(
                                          info2['deceased'].toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Center(
                                child: new StreamBuilder<DocumentSnapshot>(
                                  stream: OverviewPage._firebase
                                      .collection('countryTimeSeries')
                                      .doc('TT')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    var infoSeries1 = snapshot.data!;
                                    var maximum = maxNum(
                                        infoSeries1['deltaConfirmed'],
                                        infoSeries1['deltaRecovered']);
                                    final List<Feature> features = [
                                      Feature(
                                          title: "Recovered",
                                          color: Colors.green,
                                          data: parseSeries(
                                            infoSeries1['deltaRecovered'],
                                            maximum,
                                          )),
                                      Feature(
                                        title: "Death",
                                        color: Colors.red,
                                        data: parseSeries(
                                            infoSeries1['deltaDeceased'],
                                            maximum),
                                      ),
                                      Feature(
                                        title: "Total Cases",
                                        color: Colors.grey,
                                        data: parseSeries(
                                            infoSeries1['deltaConfirmed'],
                                            maximum),
                                      ),
                                    ];
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: LineGraph(
                                          features: features,
                                          size: Size(
                                              MediaQuery.of(context).size.width,
                                              220),
                                          labelX:
                                              getSpaces(infoSeries1['dates']),
                                          labelY: [],
                                          graphOpacity: 0.1,
                                          showDescription: true,
                                          graphColor: Colors.black87,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
            Center(
              child: new StreamBuilder<DocumentSnapshot>(
                stream: OverviewPage._firebase
                    .collection('countryWiseRecord')
                    .doc('TT')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var info = snapshot.data!;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.yellow[50],
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Cases Reported in India",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    info['confirmed'].toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800]),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Recovered",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 4),
                                          child: Text(
                                            info['recovered'].toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Deceased",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 4),
                                          child: Text(
                                            info['deceased'].toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Center(
                                  child: new StreamBuilder<DocumentSnapshot>(
                                    stream: OverviewPage._firebase
                                        .collection('countryTimeSeries')
                                        .doc('TT')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      var infoSeries = snapshot.data!;

                                      final List<Feature> features = [
                                        Feature(
                                          title: "Recovered",
                                          color: Colors.green,
                                          data: parseSeries(
                                              infoSeries['recovered'],
                                              info['confirmed']),
                                        ),
                                        Feature(
                                          title: "Deceased",
                                          color: Colors.red,
                                          data: parseSeries(
                                              infoSeries['deceased'],
                                              info['confirmed']),
                                        ),
                                        Feature(
                                          title: "Total Cases",
                                          color: Colors.grey,
                                          data: parseSeries(
                                              infoSeries['confirmed'],
                                              info['confirmed']),
                                        ),
                                      ];
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LineGraph(
                                            features: features,
                                            size: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                220),
                                            labelX:
                                                getSpaces(infoSeries['dates']),
                                            labelY: [],
                                            graphOpacity: 0.1,
                                            showDescription: true,
                                            graphColor: Colors.black87,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.blue[50],
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Tested",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    info['tested'].toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Vaccine Dose 1",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 4),
                                          child: Text(
                                            info['vaccinated1'].toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Vaccine Dose 2",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 4),
                                          child: Text(
                                            info['vaccinated2'].toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Center(
                                  child: new StreamBuilder<DocumentSnapshot>(
                                    stream: OverviewPage._firebase
                                        .collection('countryTimeSeries')
                                        .doc('TT')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      var infoSeries1 = snapshot.data!;

                                      final List<Feature> features = [
                                        // Feature(
                                        //   title: "Total Tested",
                                        //   color: Colors.purple,
                                        //   data: parseSeries(
                                        //       infoSeries['tested'],
                                        //       info['']),
                                        // ),
                                        Feature(
                                          title: "Vaccine Dose 1",
                                          color: Colors.blue,
                                          data: parseSeries(
                                              infoSeries1['vaccinated1'],
                                              info['vaccinated1']),
                                        ),
                                        Feature(
                                          title: "Vaccine Dose 2",
                                          color: Colors.deepPurple,
                                          data: parseSeries(
                                              infoSeries1['vaccinated2'],
                                              info['vaccinated1']),
                                        ),
                                      ];
                                      // print(infoSeries1['vaccinated1']);
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LineGraph(
                                            features: features,
                                            size: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                220),
                                            labelX:
                                                getSpaces(infoSeries1['dates']),
                                            labelY: [],
                                            graphOpacity: 0.1,
                                            showDescription: true,
                                            graphColor: Colors.black87,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
