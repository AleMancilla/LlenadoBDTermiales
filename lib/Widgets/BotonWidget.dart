import 'package:flutter/material.dart';
class BotonWidget extends StatelessWidget {
  final String texto;
  final Function fun;

  BotonWidget({@required this.texto, @required this.fun});

  final TextStyle _estilotexto = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]),
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(this.texto,style: _estilotexto,textAlign: TextAlign.center,),
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10.0),
      ),
    );
  }
}