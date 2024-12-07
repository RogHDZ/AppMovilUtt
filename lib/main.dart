import 'package:cunadelsabor/firebase_options.dart';
import 'package:cunadelsabor/screens/defaulthomescreen.dart';
import 'package:cunadelsabor/screens/inicio.dart';
import 'package:cunadelsabor/screens/menus/bebidasscreen.dart';
import 'package:cunadelsabor/screens/menus/entradasscreen.dart';
import 'package:cunadelsabor/screens/adminhomescreen.dart';
import 'package:cunadelsabor/screens/menus/platillosscreen.dart';
import 'package:cunadelsabor/screens/menus/postresscreen.dart';
import 'package:cunadelsabor/screens/menus/reservascreen.dart';
import 'package:cunadelsabor/screens/userhomescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => InicioScreen(),
        '/platillos': (context) => Platillosscreen(),
        '/postres': (context) => Postresscreen(),
        '/entradas': (context) => EntradasScreen(),
        '/bebidas': (context) => BebidasScreen(),
        '/reservas': (context) => ReservasScreen(),
        '/adminhomescreen': (context) => Adminhomescreen(),
        '/userhomescreen': (context) => Userhomescreen(),
        '/defaulthomescreen': (context) => Defaulthomescreen(),
      },
    );
  }
}
