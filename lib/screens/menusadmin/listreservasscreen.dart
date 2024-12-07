import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReservasScreen extends StatefulWidget {
  @override
  _AdminReservasScreenState createState() => _AdminReservasScreenState();
}

class _AdminReservasScreenState extends State<AdminReservasScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> _selectedReservas = [];

  Future<void> _eliminarReserva(String id) async {
    await db.collection('reservas').doc(id).delete();
  }

  Future<void> _eliminarSeleccionados() async {
    for (String id in _selectedReservas) {
      await _eliminarReserva(id);
    }
    setState(() {
      _selectedReservas.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedReservas.contains(id)) {
        _selectedReservas.remove(id);
      } else {
        _selectedReservas.add(id);
      }
    });
  }

  void _selectAll(List<DocumentSnapshot> reservas) {
    setState(() {
      _selectedReservas.clear();
      if (_selectedReservas.length < reservas.length) {
        for (var reserva in reservas) {
          _selectedReservas.add(reserva.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Reservas'),
        backgroundColor: const Color(0xFF7d1a49),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                _selectedReservas.isNotEmpty ? _eliminarSeleccionados : null,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('reservas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay reservas disponibles.'));
          }

          final reservas = snapshot.data!.docs;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedReservas.length < reservas.length) {
                        _selectAll(reservas);
                      } else {
                        setState(() {
                          _selectedReservas.clear();
                        });
                      }
                    },
                    child: Text(_selectedReservas.length < reservas.length
                        ? 'Seleccionar Todos'
                        : 'Deseleccionar Todos'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index];
                    return ListTile(
                      title: Text(reserva['nombre']),
                      subtitle: Text('Teléfono: ${reserva['telefono']}\n'
                          'Fecha: ${reserva['fechaReserva'].toDate().toLocal().toString().split(' ')[0]}\n'
                          'Hora: ${reserva['horaReserva']}\n'
                          'Número de Personas: ${reserva['numeroPersonas']}\n'
                          'Mesa: ${reserva['mesaSeleccionada']}\n' // Mostrar mesa
                          ),
                      trailing: Checkbox(
                        value: _selectedReservas.contains(reserva.id),
                        onChanged: (bool? value) {
                          _toggleSelection(reserva.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
