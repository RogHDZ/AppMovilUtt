import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEntradasScreen extends StatefulWidget {
  @override
  _AdminEntradasScreenState createState() => _AdminEntradasScreenState();
}

class _AdminEntradasScreenState extends State<AdminEntradasScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> _selectedEntradas = [];

  Future<void> _agregarEntrada() async {
    await db.collection('entradas').add({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': double.tryParse(_precioController.text) ?? 0.0,
    });

    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
  }

  Future<void> _eliminarEntrada(String id) async {
    await db.collection('entradas').doc(id).delete();
  }

  Future<void> _eliminarSeleccionados() async {
    for (String id in _selectedEntradas) {
      await _eliminarEntrada(id);
    }
    setState(() {
      _selectedEntradas.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedEntradas.contains(id)) {
        _selectedEntradas.remove(id);
      } else {
        _selectedEntradas.add(id);
      }
    });
  }

  void _selectAll(List<DocumentSnapshot> entradas) {
    setState(() {
      _selectedEntradas.clear();
      if (_selectedEntradas.length < entradas.length) {
        for (var entrada in entradas) {
          _selectedEntradas.add(entrada.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Entradas',
            style: TextStyle(
                color: Colors.white)), // Cambia el color de la fuente a blanco
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                _selectedEntradas.isNotEmpty ? _eliminarSeleccionados : null,
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
                decoration: InputDecoration(labelText: 'Nombre de la Entrada'),
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
              onPressed: _agregarEntrada,
              child: Text('Agregar Entrada'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('entradas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay entradas disponibles.'));
                  }

                  final entradas = snapshot.data!.docs;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedEntradas.length < entradas.length) {
                                _selectAll(entradas);
                              } else {
                                setState(() {
                                  _selectedEntradas.clear();
                                });
                              }
                            },
                            child: Text(
                                _selectedEntradas.length < entradas.length
                                    ? 'Seleccionar Todos'
                                    : 'Deseleccionar Todos'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: entradas.length,
                          itemBuilder: (context, index) {
                            final entrada = entradas[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4,
                              color: const Color(
                                  0xFFFFE082), // Color amarillo para la tarjeta
                              child: ListTile(
                                title: Text(entrada['nombre'],
                                    style: const TextStyle(
                                        color: Color(0xFF7d1a49),
                                        fontWeight: FontWeight
                                            .bold)), // Color del texto
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entrada['descripcion']),
                                    Text(
                                        'Precio: \$${entrada['precio'].toString()}',
                                        style: const TextStyle(
                                            color: Color(0xFF7d1a49),
                                            fontWeight: FontWeight
                                                .bold)), // Mostrar el precio
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: _selectedEntradas.contains(entrada.id),
                                  onChanged: (bool? value) {
                                    _toggleSelection(entrada.id);
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
