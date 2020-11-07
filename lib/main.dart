import 'package:flutter/material.dart';
import 'package:llenarbdbuses/PagesViews/HomePage.dart';
import 'package:llenarbdbuses/Provider/DataProvider.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new DataProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: HomePage(),
      ),
    );
  }
}