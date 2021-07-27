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
  // parseSeries(data, total) {
  //   List parsedData = [];
  //   for (int i = 0; i < data.length; i += 100) {
  //     parsedData
  //         .add(double.parse(int.parse(data[i].toString()) / int.parse(total.toString())));
  //   }
  //   return parsedData;
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          children: [
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
                          color: Colors.grey[50],
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Cases of India",
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
                                                fontSize: 36,
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
                                                fontSize: 36,
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
                                      print(infoSeries['dates'].toString());

                                      final List<Feature> features = [
                                        Feature(
                                          title: "Flutter",
                                          color: Colors.blue,
                                          data: [1, 0.8, 0.6, 0.7, 0.3, 0.1],
                                        ),
                                        Feature(
                                          title: "Kotlin",
                                          color: Colors.black,
                                          data: [1, 0.8, 0.6, 0.7, 0.3, 0.1],
                                        ),
                                        Feature(
                                          title: "Java",
                                          color: Colors.orange,
                                          data: [0.4, 0.2, 0.9, 0.5, 0.6, 0.4],
                                        ),
                                      ];
                                      return Container(
                                        child: LineGraph(
                                          features: features,
                                          size: Size(
                                              MediaQuery.of(context).size.width,
                                              300),
                                          labelX: [
                                            'Day 1',
                                            'Day 2',
                                            'Day 3',
                                            'Day 4',
                                            'Day 5',
                                            'Day 6'
                                          ],
                                          labelY: [
                                            ' ',
                                            ' ',
                                            ' ',
                                            ' ',
                                            ' ',
                                            ' '
                                          ],
                                          showDescription: true,
                                          graphColor: Colors.black87,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.grey[50],
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
                                            info['recovered'].toString(),
                                            style: TextStyle(
                                                fontSize: 36,
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
                                            info['deceased'].toString(),
                                            style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
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
