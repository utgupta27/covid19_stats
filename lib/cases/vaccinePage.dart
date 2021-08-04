import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:covid19_stats/vaccination/vacinationPage.dart';

class VaccinePage extends StatefulWidget {
  const VaccinePage({Key? key}) : super(key: key);

  static var date;
  static var pin;
  static getValues(p, d) {
    date = d;
    pin = p;
  }

  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  var infos;
  bool isLoading = false;
  Future<List> getData(pin, date) async {
    var formattedDate = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch));
    print(formattedDate + pin);
    String myUrl =
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=" +
            pin +
            "&date=" +
            formattedDate;
    var req = await http.get(Uri.parse(myUrl));
    infos = json.decode(req.body);
    return infos['sessions'];
  }

  int getCount(data) {
    int count = 0;
    for (var i in data) {
      print(i);
      count += 1;
    }
    return count;
  }

  getName(data, index) {
    return data[index]['name'];
  }

  getAge(data, index) {
    return data[index]['min_age_limit'];
  }

  getAvailableDose1(data, index) {
    return data[index]['available_capacity_dose1'];
  }

  getAvailableDose2(data, index) {
    return data[index]['available_capacity_dose2'];
  }

  getFeeType(data, index) {
    return data[index]['fee_type'];
  }

  getFee(data, index) {
    return data[index]['fee'];
  }

  getVaccine(data, index) {
    return data[index]['vaccine'];
  }

  getCenterId(data, index) {
    return data[index]['center_id'];
  }

  @override
  Widget build(BuildContext context) {
    print(VaccinationPage.infos);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text("Available Centers"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.waiting) {
              // print('project snapshot data is: ${projectSnap.data}');
              return Center(child: CircularProgressIndicator());
            }
            // print('project snapshot data is: ${projectSnap.data}');
            // var ind = projectSnap.data.length;
            return ListView.builder(
              itemCount: getCount(projectSnap.data),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // height: 50,
                  width: double.maxFinite,
                  child: Card(
                    child: ExpansionTile(
                      // backgroundColor: Colors.blue[100],
                      collapsedBackgroundColor: Colors.grey[100],
                      title: Text(
                        getName(projectSnap.data, index),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: ,
                      children: <Widget>[
                        Text(
                          "Vaccines Available",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Minimum Age",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    getAge(projectSnap.data, index).toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Dose 1/Dose 2",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        getAvailableDose1(
                                                projectSnap.data, index)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      Text(
                                        " / ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        getAvailableDose2(
                                                projectSnap.data, index)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Fee Type",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    getFeeType(projectSnap.data, index),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Vaccine Name",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    getVaccine(projectSnap.data, index),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Center ID",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        getCenterId(projectSnap.data, index)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Fee Amount",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: Text(
                                    "Rs. " +
                                        getFee(projectSnap.data, index)
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          future: getData(VaccinePage.pin, VaccinePage.date),
        ),
      ),
    );
  }
}
