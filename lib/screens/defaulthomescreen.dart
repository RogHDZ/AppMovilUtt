import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cunadelsabor/screens/login/login.dart';
import 'package:cunadelsabor/screens/login/userscreen.dart';
import 'package:cunadelsabor/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth

class Defaulthomescreen extends StatelessWidget {
  const Defaulthomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'La Cuna del Sabor',
      home: DefaultTabController(
        length: 2,
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instancia de Firebase Auth
  User? _user; // Variable para almacenar el usuario

  // List of titles for each button
  final List<String> titles = [
    'Platillos',
    'Postres',
    'Entradas',
    'Bebidas',
    'Reservas',
    'Lista de Reservas',
  ];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Obtiene el usuario actual
  }

  void _logout() async {
    // Muestra un diálogo de confirmación antes de cerrar sesión
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () async {
                await _auth.signOut();
                setState(() {
                  _user = null; // Actualiza el estado al cerrar sesión
                });
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 160, 144, 3),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: AppBar(
            title: Center(
              child: const Text(
                'ComidApp',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              if (_user == null)
                IconButton(
                  icon: const Icon(Icons.login, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                )
              else ...[
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _logout,
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfileScreen(user: _user!)),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 252, 233, 199), // Cambiar el color de fondo aquí
        child: Column(
          children: [
            if (_user != null) // Mensaje de bienvenida si hay sesión iniciada
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el documento
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Usuario no encontrado');
                    }

                    // Obtener el nombre de usuario del documento
                    String username = snapshot.data!['username'] ?? 'Usuario';

                    return Text(
                      'Bienvenido, sesión iniciada de: $username!',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2, // Número de columnas
                  padding: EdgeInsets.all(16.0),
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        // Navegación directa según el índice
                        switch (index) {
                          case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Platillosscreen()),
                            );
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Postresscreen()),
                            );
                            break;
                          case 2:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EntradasScreen()),
                            );
                            break;
                          case 3:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BebidasScreen()),
                            );
                            break;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              253, 205, 248, 155), // Background color
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              offset: Offset(2.0, 2.0), // Shadow offset
                              blurRadius: 5.0, // Shadow blur radius
                              spreadRadius: 1.0, // Shadow spread radius
                            ),
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Lighter shadow for depth
                              offset: Offset(-2.0, -2.0), // Shadow offset
                              blurRadius: 5.0, // Shadow blur radius
                              spreadRadius: 1.0, // Shadow spread radius
                            ),
                          ],
                          border: Border.all(
                            color:
                                Color.fromARGB(193, 245, 71, 3), // Border color
                            width: 2.0, // Border width
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.redAccent.withOpacity(0.5), // Start color
                              Colors.yellow.withOpacity(0.5), // End color
                            ],
                            begin: Alignment.topLeft, // Gradient start
                            end: Alignment.bottomRight, // Gradient end
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/${titles[index].toLowerCase()}.jpg', // Asegúrate de que el nombre de las imágenes coincida con los títulos
                              width: 100, // Ajusta el tamaño de la imagen
                              height: 100, // Ajusta el tamaño de la imagen
                            ),
                            SizedBox(
                                height:
                                    8.0), // Espacio entre la imagen y el texto
                            Text(
                              titles[index], // Usa el título de la lista
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Termcondscreen()), // Navegar a la pantalla de ayuda
          );
        },
        child: Icon(Icons.help), // Icono de ayuda
        backgroundColor: Colors.blue, // Color de fondo del botón
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // Ubicación del botón
    );
  }
}
