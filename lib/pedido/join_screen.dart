import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
export 'join_screen.dart';
import '../pages/home_page.dart';

class JoinScreen extends StatefulWidget {
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  TextEditingController partyNumberController;

  @override
  void initState() {
    super.initState();
    partyNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    partyNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Numero de Entrega"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: partyNumberController,
            decoration: InputDecoration(
              hintText: "Numero de Pedido",
            ),
          ),
          RaisedButton(
            child: Text("Ingresar"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return HomePage(
                    userId: Uuid().v1(),
                    partyNumber: partyNumberController.text,
                  );
                }),
              );
            },
          )
        ],
      ),
    );
  }
}
