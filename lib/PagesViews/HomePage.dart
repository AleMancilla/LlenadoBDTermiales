import 'package:flutter/material.dart';
import 'package:llenarbdbuses/PagesViews/RegistroDestino.dart';
import 'package:llenarbdbuses/PagesViews/RegistroEmpresas.dart';
import 'package:llenarbdbuses/PagesViews/RegistroTerminal.dart';
import 'package:llenarbdbuses/Widgets/BotonWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BotonWidget(texto: "Registro Terminal",fun:(){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegistroTerminal()));
            }),
            BotonWidget(texto: "Registro de empresas de transporte",fun:(){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegistroEmpresas()));
            }),
            BotonWidget(texto: "Registro de ruta",fun:(){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegistroDestino()));
            }),
          ],
        ),
      ),
    );
  }
}