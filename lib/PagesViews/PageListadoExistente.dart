import 'package:flutter/material.dart';
import 'package:llenarbdbuses/BD/graphql.dart';
import 'package:llenarbdbuses/PagesViews/RegistroDestino.dart';

class PageListadoExistente extends StatefulWidget {
  @override
  _PageListadoExistenteState createState() => _PageListadoExistenteState();
}

class _PageListadoExistenteState extends State<PageListadoExistente> {
  List<Widget> listaWid = [];

  @override
  void initState() {
    super.initState();
    cargandoDatos();
  }

  cargandoDatos()async{
    listaWid = await cargandoItems();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: listaWid,
        ),
      ),
    );
  }

  Future<List>cargandoItems()async{
    List aux = await obtenerListadoExistente();
    List<ItemListViajeList> listaAux = [];
        listaAux = aux.map((element){

          print("""
          =========================================
          
          ${element["Terminal"]["nombre"]}
          ${element["Empresa"]["nombreEmpresa"]}
          ${element["destino"]}
          ${element["hora"]}
          ${element["diasHabiles"]}
          ${element["costoViaje"]}
          ${element["tiempoViaje"]}
          
          =========================================
          """);

          return ItemListViajeList(
            terminal: element["Terminal"]["nombre"], 
            empresa:  element["Empresa"]["nombreEmpresa"], 
            destino:  element["destino"], 
            hora:     element["hora"], 
            dias:     element["diasHabiles"], 
            costo:    element["costoViaje"]/0.0, 
            tiempo:   element["tiempoViaje"]/0.0
          );
        }).toList();
        setState(() {
          
        });
        return listaAux;
  }
}

class ItemListViajeList extends StatefulWidget {
  final String terminal;
  final String empresa;
  final String destino;
  final String hora;
  final Map dias;
  final double costo;
  final double tiempo;

  

  const ItemListViajeList({@required this.terminal,@required this.empresa,@required this.destino,@required this.hora,@required this.dias,@required this.costo,@required this.tiempo});

  @override
  _ItemListViajeListState createState() => _ItemListViajeListState();
}

class _ItemListViajeListState extends State<ItemListViajeList> with TickerProviderStateMixin {
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextStyle estiloTexto = TextStyle(fontWeight: FontWeight.bold);
    
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(5)
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
      child: Column(
        children: [
          Row(
            children: [
              Text("Terminal Origen:\t ",style: estiloTexto,),
              Text(this.widget.terminal)
            ],
          ),

          Row(
            children: [
              Text("Empresa de transporte:\t ",style: estiloTexto,),
              Text(this.widget.empresa)
            ],
          ),

          Row(
            children: [
              Text("Destino:\t ",style: estiloTexto,),
              Text(this.widget.destino)
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Icon(Icons.timelapse),
              Text(this.widget.hora),
              SizedBox(width: 30,),
              Icon(Icons.monetization_on),
              Text(this.widget.costo.toString()+" Bs."),
              SizedBox(width: 30,),
              Icon(Icons.car_repair),
              Text(this.widget.tiempo.toString()+" Hrs."),

            ],
          ),
            RichText(
            text: TextSpan(
                // text: 'Don\'t have an account?',
                // style: TextStyle(
                //     color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  TextSpan(text: 'LU,   ',
                      style: TextStyle(
                          color: (this.widget.dias["lun"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'MA,   ',
                      style: TextStyle(
                          color: (this.widget.dias["mar"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'MI,   ',
                      style: TextStyle(
                          color: (this.widget.dias["mie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'JU,   ',
                      style: TextStyle(
                          color: (this.widget.dias["jue"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'VI,   ',
                      style: TextStyle(
                          color: (this.widget.dias["vie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'SA,   ',
                      style: TextStyle(
                          color: (this.widget.dias["sab"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                  TextSpan(text: 'DO. ',
                      style: TextStyle(
                          color: (this.widget.dias["dom"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}