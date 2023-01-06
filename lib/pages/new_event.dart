import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_f/src/field.dart';
import '../date_f/src/form_field.dart';

import '../utils.dart';

const List<String> orari = <String>['Mattina', 'Pomeriggio'];
String fasciaOraria = 'Mattina';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  _MyCustomForm createState() {
    return _MyCustomForm();
  }
}

class _MyCustomForm extends State<MyCustomForm> {
  final nomeController = TextEditingController();
  final azione = TextEditingController();
  final altro = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Event nuovoEvento;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    azione.dispose();
    altro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;

    return Scaffold(
        appBar: AppBar(
          title: Text('Nuovo Evento'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Nome Paziente',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: azione,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Tipo di Azione',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Data',
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) => (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null,
                          onDateSelected: (DateTime value) {
                            selectedDate = value;
                            print(DateFormat.yMd().format(value));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                DropdownButtonExample(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: altro,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Altro',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Event nuovoEvento = Event(
                          nomePaziente: nomeController.text,
                          azione: azione.text,
                          data: selectedDate!,
                          fasciaOraria: fasciaOraria,
                          altro: altro.text);
                      Navigator.pop(context, nuovoEvento.toString());
                    }
                  },
                  child: const Text('Crea'),
                )
              ],
            )));
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = orari.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          fasciaOraria = value;
        });
      },
      items: orari.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
