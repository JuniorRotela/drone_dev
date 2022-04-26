import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class REALTIME extends StatefulWidget {
  const REALTIME({Key key}) : super(key: key);

  @override
  State<REALTIME> createState() => _REALTIMEState();
}

class _REALTIMEState extends State<REALTIME> {
  DatabaseReference _dbref;
  String databasejson = '';
  var lat;
  var lng;

  _readdb_onechild() {
    _dbref.child("lat").child("lng").once().then((DataSnapshot dataSnapshot) {
      print(" read once - " + dataSnapshot.value.toString());
      setState(() {
        databasejson = dataSnapshot.value.toString();
      });
    });
  }

  _realdb_once() {
    _dbref.once().then((DataSnapshot dataSnapshot) {
      print(" read once - " + dataSnapshot.value.toString());
      setState(() {
        databasejson = dataSnapshot.value.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.reference();
    _readdb_onechild();
    PositionChange();
    dataChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("XD"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildText('la latitud es $lat'),
            buildText('la longitud es: $lng'),
          ],
        ),
      ),
    );
  }

  Text buildText(String s) {
    return Text(
      s,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void PositionChange() {
    _dbref.child('lat, lng').onValue.listen((Event event) {
      int data = event.snapshot.value;
      print('weight data: $data');
      setState(() {
        lat = data;
        lng = data;
      });
    });
  }

  void dataChange() {
    _dbref.onValue.listen((event) {
      print(event.snapshot.value.toString());
      Map data = event.snapshot.value;
      data.forEach((key, value) {
        setState(() {
          lat = data['lat'];
          lng = data['lng'];
        });
      });
    });
  }
}
