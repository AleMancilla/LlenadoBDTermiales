import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:llenarbdbuses/BD/graphql.dart';
import 'package:smart_select/smart_select.dart';
class RegistroDestino extends StatefulWidget {
  @override
  _RegistroDestinoState createState() => _RegistroDestinoState();
}

class _RegistroDestinoState extends State<RegistroDestino> {
  TextEditingController textControllerDestino = new TextEditingController();
  TextEditingController textControllerPasaje = new TextEditingController();
  TextEditingController textControllerEstimado = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  String terminal = 'flutter';
  String empresa = 'flutter2';
  String terminalNAME = 'flutter';
  String empresaNAME = 'flutter2';
  String hora ;
  List<S2Choice<String>> options ;
  List<S2Choice<String>> options2 ;

  bool lunes = false;
  bool martes = false;
  bool miercoles = false;
  bool jueves = false;
  bool viernes = false;
  bool sabado = false;
  bool domingo = false;

  List<ItemListViaje> listaRutasTemp = [];
  List<ItemListDestino> listaDestino = [];

  @override
  void initState() {
    super.initState();
    _llenarDatos();
  }

  _llenarDatos()async{
    List dataBD = await obtenerTerminales();
    // print(dataBD);
    options = dataBD.map((dato) {
      return S2Choice<String>(value: dato["terminalID"], title: dato["nombre"]);
    }).toList();

    List dataBD2 = await obtenerEmpresa();
    // print(dataBD);
    options2 = dataBD2.map((dato) {
      return S2Choice<String>(value: dato["idEmpresa"], title: dato["nombreEmpresa"]);
    }).toList();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "no tag",
          child: Icon(Icons.upgrade),
          onPressed: () => scrollController.animateTo(150,curve: Curves.linear,duration: Duration(milliseconds: 500)),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: GestureDetector(
            onTap:  () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25,),
                  Container(width: size.width*0.7,child: Text("REGISTRO DE RUTA",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                  SizedBox(height: 25,),

                  SmartSelect<String>.single(
                    title: 'Selecciona Terminal',
                    value: terminal,
                    choiceItems: options??[],
                    onChange: (state) => setState(() {
                      terminalNAME = state.valueTitle;
                      terminal = state.value;})
                  ),

                  SmartSelect<String>.single(
                    title: 'Selecciona Empresa',
                    value: empresa,
                    choiceItems: options2??[],
                    onChange: (state) => setState(() {
                      empresaNAME = state.valueTitle;
                      //print(state.valueTitle);
                      empresa = state.value;})
                  ),

                  _labelDestino(),

                  SizedBox(height: 15,),
                  FloatingActionButton.extended(
                    onPressed: () {
                        DatePicker.showTime12hPicker(context,
                          showTitleActions: true,

                          onChanged: (date) {
                            print('change $date');
                          }, 
                          onConfirm: (date) {
                            hora = "${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}" ;
                            setState(() {
                              
                            });
                            print('${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}');
                          }, 
                        );
                      },
                    label: Text(
                        (hora != null)?"Hora de salida: $hora":"Selecciona la hora",
                        style: TextStyle(color: Colors.white),
                    )
                  ),

                  SizedBox(height: 15,),
                  _labelDias(),

                  _labelCosto(context),
                  _labelEstimado(context),
                  _botonGuardar(),

                  ...listaRutasTemp,

                  _botonEnviar()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _labelDestino(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Column(
        children: [
          Text("Indique el lugar de Destino:"),
          Container(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: textControllerDestino,
            ),
          )
        ],
      ),
    );
  }

  _labelCosto(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            child: Text("Costo de pasaje:")),
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: textControllerPasaje,
            ),
          ),
          Text("Bs."),

        ],
      ),
    );
  }
  _labelEstimado(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            child: Text("Tiempo de viaje estimado:")),
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: textControllerEstimado,
            ),
          ),
          Text("Horas."),

        ],
      ),
    );
  }
  _labelDias(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Column(
        children: [
          Text("Indique Los dias de Salida habilitadas:"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Lun"),
                    Checkbox(
                      value: lunes,
                      onChanged: (bool value) {
                        setState(() {
                          lunes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Tuesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Mar"),
                    Checkbox(
                      value: martes,
                      onChanged: (bool value) {
                        setState(() {
                          martes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Wednesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Mie"),
                    Checkbox(
                      value: miercoles,
                      onChanged: (bool value) {
                        setState(() {
                          miercoles = value;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Jue"),
                    Checkbox(
                      value: jueves,
                      onChanged: (bool value) {
                        setState(() {
                          jueves = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Tuesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Vie"),
                    Checkbox(
                      value: viernes,
                      onChanged: (bool value) {
                        setState(() {
                          viernes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Wednesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sab"),
                    Checkbox(
                      value: sabado,
                      onChanged: (bool value) {
                        setState(() {
                          sabado = value;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Dom"),
                    Checkbox(
                      value: domingo,
                      onChanged: (bool value) {
                        setState(() {
                          domingo = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  _botonGuardar(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: CupertinoButton(
        onPressed: () async {

          // print("""
          
          // $terminalNAME 
          // $empresaNAME  
          // ${textControllerDestino.text}
          // ${textControllerEstimado.text}
          // ${textControllerPasaje.text}
          // lun , mar , mie , jue , vie , sab , dom
          // $lunes , $martes , $miercoles , $jueves , $viernes , $sabado , $domingo
          // $hora
          
          // """);

          ItemListViaje itemAux = new ItemListViaje(
            terminal: terminalNAME, 
            empresa: empresaNAME, 
            destino: textControllerDestino.text, 
            hora: hora, 
            dias: {
              "lun":lunes,
              "mar":martes,
              "mie":miercoles,
              "jue":jueves,
              "vie":viernes,
              "sab":sabado,
              "dom":domingo
            }, 
            costo: double.parse(textControllerPasaje.text), 
            tiempo: double.parse(textControllerEstimado.text));

          listaRutasTemp.add(itemAux);

          ItemListDestino destino = ItemListDestino(
            terminal: terminal, 
            empresa: empresa, 
            destino: textControllerDestino.text, 
            hora: hora, 
            dias: {
              "lun":lunes,
              "mar":martes,
              "mie":miercoles,
              "jue":jueves,
              "vie":viernes,
              "sab":sabado,
              "dom":domingo
            }, 
            costo: double.parse(textControllerPasaje.text), 
            tiempo: double.parse(textControllerEstimado.text)
          );
          listaDestino.add(destino);
          setState(() {
            
          });
          
          Future.delayed(Duration(milliseconds: 100),(){
            scrollController.animateTo(scrollController.position.maxScrollExtent, curve: Curves.linear,duration: Duration (milliseconds: 500));
          });
          // Flushbar(
          //         title:  "Enviando datos a backend",
          //         message:  "Porfavor espera unos segundos mientras se completa la accion",
          //         duration:  Duration(seconds: 2),
          //         backgroundColor: Colors.orange,             
          //       )..show(context);
          // print("===== $value");
          // bool state = await insertarEmpresa(
          //   idTerminal: value,
          //   imageURL: "url https//",
          //   nombreEmp: textControllername.text,
          //   numContacto: textControllernumber.text
          // );

          // if(state){
          //   Flushbar(
          //     title:  "Aceptado",
          //     message:  "El dato fue completado exitosamente",
          //     duration:  Duration(seconds: 3),              
          //     backgroundColor: Colors.green,
          //   )..show(context);
          //   new Future.delayed(Duration(milliseconds: 3001),() {
          //     Navigator.pop(context);
          //   });
          // }else{
          //   Flushbar(
          //     title:  "ERROR",
          //     message:  "Sucedio un error por favor verifica tu conexion y que tu GPS este activado",
          //     duration:  Duration(seconds: 3),              
          //     backgroundColor: Colors.red,
          //   )..show(context);
          // }
        },
        child: Text("GUARDAR REGISTRO DE RUTA"),
        color: Colors.orange,
      ),
    );
  }


  _botonEnviar(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: CupertinoButton(
        onPressed: () async {
          // Navigator.pop(context);
          // bool state = await insertarDestino(
          //   idTerminal: terminal,
          //   idEmpresa: empresa,
          //   destino: textControllerDestino.text,
          //   hora: hora,
          //   diasHabiles: {
          //     "lun":lunes,
          //     "mar":martes,
          //     "mie":miercoles,
          //     "jue":jueves,
          //     "vie":viernes,
          //     "sab":sabado,
          //     "dom":domingo
          //   },
          //   costoViaje: double.parse(textControllerPasaje.text),
          //   tiempoViaje: double.parse(textControllerEstimado.text)
          // );
          bool state = true;
          listaDestino.forEach((ItemListDestino element) async { 
            if(state){
              state = await insertarDestino(
                idTerminal: element.terminal,
                idEmpresa: element.empresa,
                destino: element.destino,
                hora: element.hora,
                diasHabiles: element.dias,
                costoViaje: element.costo,
                tiempoViaje: element.tiempo
              );
            }
          });

          Flushbar(
                  title:  "Enviando datos a backend",
                  message:  "Porfavor espera unos segundos mientras se completa la accion",
                  duration:  Duration(seconds: 2),
                  backgroundColor: Colors.orange,             
                )..show(context);
          // print("===== $value");
          // bool state = await insertarEmpresa(
          //   idTerminal: value,
          //   imageURL: "url https//",
          //   nombreEmp: textControllername.text,
          //   numContacto: textControllernumber.text
          // );

          if(state){
            Flushbar(
              title:  "Aceptado",
              message:  "El dato fue completado exitosamente",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.green,
            )..show(context);
            new Future.delayed(Duration(milliseconds: 3001),() {
              Navigator.pop(context);
            });
          }else{
            Flushbar(
              title:  "ERROR",
              message:  "Sucedio un error por favor verifica tu conexion y que tu GPS este activado",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.red,
            )..show(context);
          }
        },
        child: Text("Guardar transporte"),
        color: Colors.green,
      ),
    );
  }
}


class ItemListViaje extends StatefulWidget {
  final String terminal;
  final String empresa;
  final String destino;
  final String hora;
  final Map dias;
  final double costo;
  final double tiempo;

  

  const ItemListViaje({@required this.terminal,@required this.empresa,@required this.destino,@required this.hora,@required this.dias,@required this.costo,@required this.tiempo});

  @override
  _ItemListViajeState createState() => _ItemListViajeState();
}

class _ItemListViajeState extends State<ItemListViaje> with TickerProviderStateMixin {
    Animation<Color> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    _animation = ColorTween(begin: Colors.green,
       end: Colors.purple[50],
    ).animate(_controller)..addListener(() {
      setState((){});
    });
    // Tell the animation to start
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextStyle estiloTexto = TextStyle(fontWeight: FontWeight.bold);
    
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: _animation.value,
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

class ItemListDestino {
  String terminal;
  String empresa;
  String destino;
  String hora;
  Map    dias;
  double costo;
  double tiempo;

  ItemListDestino(
  { @required this.terminal,
    @required this.empresa,
    @required this.destino,
    @required this.hora,
    @required this.dias,
    @required this.costo,
    @required this.tiempo,
    });
}