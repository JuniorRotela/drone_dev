import 'package:google_maps/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/blocs/pages/home/bloc.dart';
import 'package:google_maps/blocs/pages/home/home_bloc.dart';
import 'package:google_maps/blocs/pages/home/home_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class BottomView extends StatelessWidget {
  const BottomView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBloc.of(context);

    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      final bool confirm = state.origin != null && state.destination != null;

      final bool confirmEnabled = state.reverseGeocodeTask != null &&
          state.reverseGeocodeTask.place != null;

      return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              width: 60,
              height: 4,
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4)),
            ),
            if (state.mapPick == MapPick.none)
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: confirm ? Color(0xff102027) : Color(0xffd2d2d2),
                  child: Text(
                    confirm
                        ? "Esperar Pedido"
                        : "Definir Ubicacion de Entrega?",
                    style: TextStyle(
                      color: confirm ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (confirm) {
                      
                    } else {
                      bloc.whereYouGo();
                    }
                  },
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: Color(0xff102027),
                  child: Text(
                    "Confirmar ${state.mapPick == MapPick.origin ? "origen" : "destino"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: confirmEnabled
                      ? () {
                          final bool isOrigin = state.mapPick == MapPick.origin;
                          bloc.add(
                            ConfirmPoint(
                              state.reverseGeocodeTask.place,
                              isOrigin,
                            ),
                          );
                          print(
                              "su latitud xdxd $Place.PositionLatLng(coords[0] = latitude)}, frezcoxdxd $state.longitude} ");
                        }
                      : null,
                ),
              )
          ],
        ),
      );
    });
  }
}

class HomeEvent {
  static HomeEvents confirm({Place origin, Place destination}) {}
}
