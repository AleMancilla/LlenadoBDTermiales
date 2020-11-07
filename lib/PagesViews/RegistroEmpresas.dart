
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future getImageGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
                    ),

                    Text("Foto o logo de la empresa:"),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.add_a_photo),
                              color: Colors.orange,
                              iconSize: 50,
                            ),
                            IconButton(
                              onPressed: () {
                                getImageGalery();
                              },
                              icon: Icon(Icons.image_search),
                              color: Colors.orange,
                              iconSize: 50,
                            ),
                          ],
                        ),

                        _image == null
                        ? Container(
                          color: Colors.grey,
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: Text("No seleccionaste ninguna imagen",textAlign: TextAlign.center,)
                          )
                        : Container(
                          color: Colors.transparent,
                            width: 200,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image,fit: BoxFit.cover,))
                          ),
                      ],
                    ),

                    SizedBox(height: 35,),
                    _botonEnviar(),
                    SizedBox(height: 35,),

                      
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

  _botonEnviar(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: CupertinoButton(
        onPressed: () async {
          Flushbar(
                  title:  "Enviando datos a backend",
                  message:  "Porfavor espera unos segundos mientras se completa la accion",
                  duration:  Duration(seconds: 2),
                  backgroundColor: Colors.orange,             
                )..show(context);
          print("===== $value");
          bool state = await insertarEmpresa(
            idTerminal: value,
            imageURL: "url https//",
            nombreEmp: textControllername.text,
            numContacto: textControllernumber.text
          );

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
        color: Colors.orange,
      ),
    );
  }
}

