import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
      ),
      body: Container(
        color: const Color(0xFFFFF8E1), // Fondo amarillo claro
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Correo Electrónico:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7d1a49)),
              ),
              Text(
                user.email ?? 'No disponible',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7d1a49)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reservas realizadas:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7d1a49)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('reservas')
                      .where('userId',
                          isEqualTo: user.uid) // Filtra por el ID del usuario
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('No hay reservas disponibles.'));
                    }

                    final reservas = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              reserva['nombre'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7d1a49)),
                            ),
                            subtitle: Text(
                              'Teléfono: ${reserva['telefono']}\n'
                              'Fecha: ${reserva['fechaReserva'].toDate().toLocal().toString().split(' ')[0]}\n'
                              'Hora: ${reserva['horaReserva']}\n'
                              'Número de Personas: ${reserva['numeroPersonas']}\n'
                              'Mesa: ${reserva['mesaSeleccionada'] ?? 'No asignada'}\n', // Mostrar mesa
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
