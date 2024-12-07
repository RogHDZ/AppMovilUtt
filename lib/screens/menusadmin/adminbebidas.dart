import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBebidasScreen extends StatefulWidget {
  @override
  _AdminBebidasScreenState createState() => _AdminBebidasScreenState();
}

class _AdminBebidasScreenState extends State<AdminBebidasScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> _selectedBebidas = [];

  Future<void> _agregarBebida() async {
    await db.collection('bebidas').add({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': double.tryParse(_precioController.text) ?? 0.0,
    });

    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
  }

  Future<void> _eliminarBebida(String id) async {
    await db.collection('bebidas').doc(id).delete();
  }

  Future<void> _eliminarSeleccionados() async {
    for (String id in _selectedBebidas) {
      await _eliminarBebida(id);
    }
    setState(() {
      _selectedBebidas.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedBebidas.contains(id)) {
        _selectedBebidas.remove(id);
      } else {
        _selectedBebidas.add(id);
      }
    });
  }

  void _selectAll(List<DocumentSnapshot> bebidas) {
    setState(() {
      _selectedBebidas.clear();
      if (_selectedBebidas.length < bebidas.length) {
        for (var bebida in bebidas) {
          _selectedBebidas.add(bebida.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Bebidas',
            style: TextStyle(
                color: Colors.white)), // Cambia el color de la fuente a blanco
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:
                _selectedBebidas.isNotEmpty ? _eliminarSeleccionados : null,
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
                decoration: InputDecoration(labelText: 'Nombre de la Bebida'),
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
              onPressed: _agregarBebida,
              child: Text('Agregar Bebida'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('bebidas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay bebidas disponibles.'));
                  }

                  final bebidas = snapshot.data!.docs;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedBebidas.length < bebidas.length) {
                                _selectAll(bebidas);
                              } else {
                                setState(() {
                                  _selectedBebidas.clear();
                                });
                              }
                            },
                            child: Text(_selectedBebidas.length < bebidas.length
                                ? 'Seleccionar Todos'
                                : 'Deseleccionar Todos'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: bebidas.length,
                          itemBuilder: (context, index) {
                            final bebida = bebidas[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4,
                              color: const Color(
                                  0xFFFFE082), // Color amarillo para la tarjeta
                              child: ListTile(
                                title: Text(bebida['nombre'],
                                    style: const TextStyle(
                                        color: Color(0xFF7d1a49),
                                        fontWeight: FontWeight
                                            .bold)), // Color del texto
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(bebida['descripcion']),
                                    Text(
                                        'Precio: \$${bebida['precio'].toString()}',
                                        style: const TextStyle(
                                            color: Color(0xFF7d1a49),
                                            fontWeight: FontWeight
                                                .bold)), // Mostrar el precio
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: _selectedBebidas.contains(bebida.id),
                                  onChanged: (bool? value) {
                                    _toggleSelection(bebida.id);
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
