import 'package:flutter/material.dart';
import 'package:llenarbdbuses/BD/graphql.dart';
import 'package:smart_select/smart_select.dart';

class RegistroEmpresas extends StatefulWidget {

  // simple usage

  @override
  _RegistroEmpresasState createState() => _RegistroEmpresasState();
}

class _RegistroEmpresasState extends State<RegistroEmpresas> {
  String value = 'flutter';
  TextEditingController textControllername = new TextEditingController();
  TextEditingController textControllernumber = new TextEditingController();
  List<S2Choice<String>> options ;
  // = [
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  //   S2Choice<String>(value: 'ion', title: 'Ionic'),
  //   S2Choice<String>(value: 'flu', title: 'Flutter'),
  //   S2Choice<String>(value: 'rea', title: 'React Native'),
  // ];
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
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SizedBox(height: 25,),
                    Container(width: size.width*0.7,child: Text("REGISTRO DE EMPRESA DE TRANSPORTE",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                    SizedBox(height: 25,),
                    _labelNombreEmpresa(),
                    _labelNumeroContact(),
                    SizedBox(height: 15,),
                    SmartSelect<String>.single(
                      title: 'Selecciona Terminal',
                      value: value,
                      choiceItems: options??[],
                      onChange: (state) => setState(() => value = state.value)
                    )
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _labelNombreEmpresa (){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Column(
        children: [
          Text("Nombre de Empresa:"),
          Container(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: textControllername,
            ),
          )
        ],
      ),
    );
  }

  _labelNumeroContact (){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Column(
        children: [
          Text("Numero de contacto:"),
          Container(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: textControllernumber,
            ),
          )
        ],
      ),
    );
  }
}