import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPlatillosScreen extends StatefulWidget {
  @override
  _AdminPlatillosScreenState createState() => _AdminPlatillosScreenState();
}

class _AdminPlatillosScreenState extends State<AdminPlatillosScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> _selectedPlatillos = [];

  Future<void> _agregarPlatillo() async {
    await db.collection('platillos').add({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': double.tryParse(_precioController.text) ?? 0.0,
    });

    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
  }

  Future<void> _eliminarPlatillo(String id) async {
    await db.collection('platillos').doc(id).delete();
  }

  Future<void> _eliminarSeleccionados() async {
    for (String id in _selectedPlatillos) {
      await _eliminarPlatillo(id);
    }
    setState(() {
      _selectedPlatillos.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedPlatillos.contains(id)) {
        _selectedPlatillos.remove(id);
      } else {
        _selectedPlatillos.add(id);
      }
    });
  }

  void _selectAll(List<DocumentSnapshot> platillos) {
    setState(() {
      _selectedPlatillos.clear();
      if (_selectedPlatillos.length < platillos.length) {
        for (var platillo in platillos) {
          _selectedPlatillos.add(platillo.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Platillos',
            style: TextStyle(
                color: Colors.white)), // Cambia el color de la fuente a blanco
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                _selectedPlatillos.isNotEmpty ? _eliminarSeleccionados : null,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF8E1), // Fondo amarillo claro
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Platillo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: _agregarPlatillo,
              child: Text('Agregar Platillo'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('platillos').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay platillos disponibles.'));
                  }

                  final platillos = snapshot.data!.docs;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedPlatillos.length <
                                  platillos.length) {
                                _selectAll(platillos);
                              } else {
                                setState(() {
                                  _selectedPlatillos.clear();
                                });
                              }
                            },
                            child: Text(
                                _selectedPlatillos.length < platillos.length
                                    ? 'Seleccionar Todos'
                                    : 'Deseleccionar Todos'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: platillos.length,
                          itemBuilder: (context, index) {
                            final platillo = platillos[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4,
                              color: const Color(
                                  0xFFFFE082), // Color amarillo para la tarjeta
                              child: ListTile(
                                title: Text(platillo['nombre'],
                                    style: const TextStyle(
                                        color: Color(0xFF7d1a49),
                                        fontWeight: FontWeight
                                            .bold)), // Color del texto
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(platillo['descripcion']),
                                    Text(
                                        'Precio: \$${platillo['precio'].toString()}',
                                        style: const TextStyle(
                                            color: Color(0xFF7d1a49),
                                            fontWeight: FontWeight
                                                .bold)), // Mostrar el precio
                                  ],
                                ),
                                trailing: Checkbox(
                                  value:
                                      _selectedPlatillos.contains(platillo.id),
                                  onChanged: (bool? value) {
                                    _toggleSelection(platillo.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
