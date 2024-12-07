import 'package:cunadelsabor/screens/defaulthomescreen.dart';
import 'package:cunadelsabor/screens/login/login.dart';
import 'package:cunadelsabor/screens/login/register.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Asegúrate de tener esta pantalla de registro

class InicioScreen extends StatefulWidget {
  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  void initState() {
    super.initState();
    // Aquí puedes agregar lógica para verificar si el usuario ya está autenticado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellowAccent,
              Colors.orangeAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Animación Lottie
              Lottie.asset('assets/Animationfood.json',
                  width: 200, height: 200),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Bienvenido a ComidApp',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de inicio de sesión
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Iniciar Sesión'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Registrarse'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla principal sin iniciar sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Defaulthomescreen()),
                  );
                },
                child: Text(
                  'Entrar sin iniciar sesión',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Negrita
                    decoration: TextDecoration.underline, // Subrayado
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
