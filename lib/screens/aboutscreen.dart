import 'package:cunadelsabor/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Aboutscreen());

class Aboutscreen extends StatelessWidget {
  const Aboutscreen({super.key});

  @override
  Widget build(BuildContext context) {
    //quitar esto antes de empezar a hacer las rutas
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
    return MaterialApp(
      //quitar esto antes de empezar a hacer las rutas
      navigatorKey: navigatorKey,
      title: '',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ComidApp',
            style: TextStyle(
                color: Colors.white), // Cambia el color de la fuente a blanco
          ),
          backgroundColor: const Color(0xFF7d1a49),
          //quitar esto antes de empezar a hacer las rutas

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
          ),

          //quitar esto antes de empezar a hacer las rutas
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Acerca de Nosotros',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Espacio entre el título y el texto
                Text(
                  'Historia:'
                  'Ubicado en el corazón de Huamantla, nuestro restaurante nació con la idea de crear un espacio que refleje la rica tradición culinaria de la región y brinde una experiencia única para las familias. Desde su apertura, hemos trabajado para ofrecer un ambiente acogedor, abierto a todo el público, pero con un enfoque especial en crear momentos inolvidables para familias que buscan disfrutar de buena comida en un entorno cálido. Nuestra pasión por la gastronomía local y el deseo de compartir las raíces mexicanas con nuestros visitantes ha sido el motor de nuestro éxito. '
                  'Misión'
                  'Nuestra misión es ofrecer a nuestros clientes una experiencia gastronómica que celebre la riqueza de la cocina tradicional mexicana, con un enfoque especial en los sabores de Huamantla. Buscamos ser un espacio donde las familias puedan reunirse, disfrutar de deliciosos platillos y crear recuerdos inolvidables.'
                  'Valores'
                  'Calidad: Nos comprometemos a ofrecer siempre lo mejor, desde la selección de ingredientes frescos hasta la presentación de cada plato.'
                  ' '
                  'Tradición: Valoramos y preservamos la esencia de la cocina mexicana, transmitiendo su historia a través de nuestros platillos.'
                  ' '
                  'Familia: Fomentamos un ambiente en el que las familias puedan conectarse, relajarse y disfrutar de tiempo de calidad juntas.'
                  ' '
                  'Sostenibilidad: Creemos en el uso responsable de los recursos y apoyamos a los productores locales en Huamantla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
