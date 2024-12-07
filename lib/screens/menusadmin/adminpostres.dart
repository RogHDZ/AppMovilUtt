import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPostresScreen extends StatefulWidget {
  @override
  _AdminPostresScreenState createState() => _AdminPostresScreenState();
}

class _AdminPostresScreenState extends State<AdminPostresScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> _selectedPostres = [];

  Future<void> _agregarPostre() async {
    await db.collection('postres').add({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': double.tryParse(_precioController.text) ?? 0.0,
    });

    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
  }

  Future<void> _eliminarPostre(String id) async {
    await db.collection('postres').doc(id).delete();
  }

  Future<void> _eliminarSeleccionados() async {
    for (String id in _selectedPostres) {
      await _eliminarPostre(id);
    }
    setState(() {
      _selectedPostres.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedPostres.contains(id)) {
        _selectedPostres.remove(id);
      } else {
        _selectedPostres.add(id);
      }
    });
  }

  void _selectAll(List<DocumentSnapshot> postres) {
    setState(() {
      _selectedPostres.clear();
      if (_selectedPostres.length < postres.length) {
        for (var postre in postres) {
          _selectedPostres.add(postre.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Postres',
            style: TextStyle(
                color: Colors.white)), // Cambia el color de la fuente a blanco
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                _selectedPostres.isNotEmpty ? _eliminarSeleccionados : null,
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
                decoration: InputDecoration(labelText: 'Nombre del Postre'),
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
              onPressed: _agregarPostre,
              child: Text('Agregar Postre'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('postres').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay postres disponibles.'));
                  }

                  final postres = snapshot.data!.docs;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedPostres.length < postres.length) {
                                _selectAll(postres);
                              } else {
                                setState(() {
                                  _selectedPostres.clear();
                                });
                              }
                            },
                            child: Text(_selectedPostres.length < postres.length
                                ? 'Seleccionar Todos'
                                : 'Deseleccionar Todos'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: postres.length,
                          itemBuilder: (context, index) {
                            final postre = postres[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4,
                              color: const Color(
                                  0xFFFFE082), // Color amarillo para la tarjeta
                              child: ListTile(
                                title: Text(postre['nombre'],
                                    style: const TextStyle(
                                        color: Color(0xFF7d1a49),
                                        fontWeight: FontWeight
                                            .bold)), // Color del texto
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(postre['descripcion']),
                                    Text(
                                        'Precio: \$${postre['precio'].toString()}',
                                        style: const TextStyle(
                                            color: Color(0xFF7d1a49),
                                            fontWeight: FontWeight
                                                .bold)), // Mostrar el precio
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: _selectedPostres.contains(postre.id),
                                  onChanged: (bool? value) {
                                    _toggleSelection(postre.id);
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
