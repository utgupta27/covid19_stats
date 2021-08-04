import 'package:covid19_stats/cases/vaccinePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class VaccinationPage extends StatefulWidget {
  // const VaccinationPage({Key? key}) : super(key: key);
  static var infos;
  // VaccinationPage() {
  //   getData();
  // }

  static getData(pin, date) async {
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
    // print(infos);
  }

  @override
  _VaccinationPageState createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  var pin = TextEditingController();

  DateTime _date = DateTime.now();

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2030, 12),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Lottie.asset(
                "assets/59933-covid-19-vaccine-concept-animation.json"),
          ),
          Container(
            child: Column(
              children: [
                // Implement Search Widgets here
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: pin,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Pincode ',
                        filled: true,
                        // fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // validator: (value) => EmailValidator.validate(value!)
                      //     ? null
                      //     : "Please enter a valid email",
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 0,
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            primary: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        onPressed: _selectDate,
                        child: Text('Select Date'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Selected DATE: ' +
                            DateFormat('dd-MM-yyyy').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    _date.microsecondsSinceEpoch)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        // VaccinationPage.getData(pin.text, _date);
                        VaccinePage.date = _date;
                        VaccinePage.pin = pin.text;
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => new VaccinePage()),
                        );
                      },
                      child: Text("Search")),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
