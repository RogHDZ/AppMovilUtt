import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservasScreen extends StatefulWidget {
  @override
  Reservascreen createState() => Reservascreen();
}

class Reservascreen extends State<ReservasScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _telefono = '';
  DateTime? _fechaReserva;
  TimeOfDay? _horaReserva;
  int _numeroPersonas = 1;
  bool _terminosAceptados = false;
  String? _mesaSeleccionada;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ComidApp',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFFC107), // Color amarillo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFFFF8E1), // Fondo amarillo claro
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _nombre = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Número de Teléfono',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu número de teléfono';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _telefono = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de Reserva',
                    hintText: _fechaReserva != null
                        ? '${_fechaReserva!.day}/${_fechaReserva!.month}/${_fechaReserva!.year}'
                        : 'Selecciona una fecha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _fechaReserva ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaReserva = pickedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (_fechaReserva == null) {
                      return 'Selecciona una fecha de reserva';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Hora de Reserva',
                    hintText: _horaReserva != null
                        ? formatTimeOfDay(_horaReserva!)
                        : 'Selecciona una hora',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _horaReserva ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _horaReserva = pickedTime;
                      });
                    }
                  },
                  validator: (value) {
                    if (_horaReserva == null) {
                      return 'Selecciona una hora de reserva';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Número de Personas',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el número de personas';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numeroPersonas = int.tryParse(value) ?? 1;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Selecciona una Mesa',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  value: _mesaSeleccionada,
                  items: [
                    'Mesa 1',
                    'Mesa 2',
                    'Mesa 3',
                    'Mesa 4',
                    'Mesa 5',
                  ].map((mesa) {
                    return DropdownMenuItem<String>(
                      value: mesa,
                      child: Text(mesa),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _mesaSeleccionada = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una mesa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('Acepto los términos y condiciones'),
                  value: _terminosAceptados,
                  onChanged: (value) {
                    setState(() {
                      _terminosAceptados = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _terminosAceptados) {
                      User? user = auth.currentUser;

                      await db.collection('reservas').add({
                        'nombre': _nombre,
                        'telefono': _telefono,
                        'fechaReserva': dateTimeToTimestamp(_fechaReserva!),
                        'horaReserva': formatTimeOfDay(_horaReserva!),
                        'numeroPersonas': _numeroPersonas,
                        'mesaSeleccionada': _mesaSeleccionada,
                        'userId': user?.uid,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reserva realizada con éxito.'),
                        ),
                      );

                      _formKey.currentState!.reset();
                      setState(() {
                        _nombre = '';
                        _telefono = '';
                        _fechaReserva = null;
                        _horaReserva = null;
                        _numeroPersonas = 1;
                        _mesaSeleccionada = null;
                        _terminosAceptados = false;
                      });
                    } else if (!_terminosAceptados) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Debes aceptar los términos y condiciones'),
                        ),
                      );
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
