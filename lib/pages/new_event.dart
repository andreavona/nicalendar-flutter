import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_f/src/field.dart';
import '../date_f/src/form_field.dart';

import '../utils.dart';

const List<String> orari = <String>['Mattina', 'Pomeriggio'];
String fasciaOraria = 'Mattina';

const List<String> terapie = <String>[
  'Terapia/Controlli Clinici',
  'Videat',
  'Terapia Educazionale',
  'Chiamate',
  'Esami Diagnostici/Strumentali',
  'Altro'
];
String primaTerapia = 'Terapia/Controlli Clinici';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.initialValue});
  final DateTime initialValue;

  @override
  _MyCustomForm createState() {
    return _MyCustomForm();
  }
}

class _MyCustomForm extends State<MyCustomForm> {
  final nomeController = TextEditingController();
  final cognomeController = TextEditingController();
  final azione = TextEditingController();
  final altro = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
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
                        return 'Immetti il nome del paziente';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: cognomeController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Cognome Paziente',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Immetti il cognome del paziente';
                      }
                      return null;
                    },
                  ),
                ),
                DropdownButtonOrari(list: terapie, firstItem: primaTerapia),
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
                        return 'Scegli l\'azione';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Form(
                    key: _formKey2,
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
                          mode: DateTimeFieldPickerMode.date,
                          initialValue: widget.initialValue,
                          //autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) {
                            if (e == null) {
                              return 'Scegli la Data';
                            }
                            return null;
                          },
                          onDateSelected: (DateTime value) {
                            selectedDate = value;
                            print(DateFormat.yMd().format(value));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                DropdownButtonOrari(list: orari, firstItem: fasciaOraria),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: altro,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Altro',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _formKey2.currentState!.validate()) {
                      selectedDate ??= widget.initialValue;
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Event nuovoEvento = Event(
                          nomePaziente: nomeController.text.capitalize(),
                          cognomePaziente: cognomeController.text.capitalize(),
                          terapia: primaTerapia,
                          azione: azione.text,
                          data: selectedDate!,
                          fasciaOraria: fasciaOraria,
                          altro: altro.text,
                          cancellato: false);
                      Navigator.pop(context, nuovoEvento);
                    }
                  },
                  child: const Text('Crea'),
                )
              ],
            )));
  }
}

class DropdownButtonOrari extends StatefulWidget {
  DropdownButtonOrari({super.key, required this.list, required this.firstItem});
  final List<String> list;
  String firstItem;

  @override
  State<DropdownButtonOrari> createState() => _DropdownButtonOrariState();
}

class _DropdownButtonOrariState extends State<DropdownButtonOrari> {
  //String dropdownValue = orari.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.firstItem,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          widget.firstItem = value!;
          //fasciaOraria = value;
          if (widget.list.contains('Mattina')) {
            fasciaOraria = value;
          } else {
            primaTerapia = value;
          }
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class AutocompleteTextField extends StatelessWidget {
  const AutocompleteTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}
