import 'package:flutter/material.dart';

class Termcondscreen extends StatelessWidget {
  const Termcondscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ComidApp',
          style: TextStyle(
              color: Colors.white), // Cambia el color de la fuente a blanco
        ),
        backgroundColor: const Color(0xFF7d1a49),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: SingleChildScrollView(
        // Agregar SingleChildScrollView aquí
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Términos y Condiciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espacio entre el título y el texto
              Padding(
                padding:
                    const EdgeInsets.all(16.0), // Añadir un poco de padding
                child: Text(
                  'Al utilizar la aplicación ComidApp, el usuario acepta los presentes Términos y Condiciones. ComidApp es una herramienta diseñada exclusivamente como un catálogo de menús y para realizar reservas en el restaurante asociado, y no permite realizar compras a través de la aplicación. Para hacer reservas, el usuario deberá registrarse proporcionando su nombre completo, correo electrónico y número de teléfono, los cuales serán utilizados únicamente para confirmar y gestionar las reservas, enviar notificaciones relacionadas con las mismas y, en caso de autorización, para informar sobre promociones o actualizaciones del restaurante. Estos datos serán tratados de forma confidencial y no se compartirán con terceros, salvo cuando sea requerido por ley. El usuario se compromete a proporcionar información veraz, a utilizar la aplicación conforme a su propósito y a no intentar manipular su funcionalidad. ComidApp no se hace responsable por cancelaciones de reservas, errores en los datos proporcionados por el usuario o problemas técnicos en los dispositivos del usuario. Todos los derechos de la aplicación, incluyendo su diseño y contenido, son propiedad exclusiva del restaurante o sus desarrolladores, quedando prohibido su uso sin autorización. ComidApp se reserva el derecho de modificar estos términos en cualquier momento, notificando los cambios a través de la aplicación o por correo electrónico. El usuario puede solicitar la cancelación de su cuenta y la eliminación de sus datos personales contactándonos a través de los medios indicados en la aplicación. Estos términos se rigen por las leyes de [país o región] y cualquier disputa será resuelta por los tribunales competentes de [ciudad o país]. Para dudas o aclaraciones, el usuario puede comunicarse por correo electrónico a [correo de soporte] o por teléfono al [número de contacto].',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
