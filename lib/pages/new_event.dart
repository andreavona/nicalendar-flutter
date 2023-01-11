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
  MyCustomForm({super.key, required this.initialValue, this.eventToUpdate});
  final DateTime initialValue;
  Event? eventToUpdate;

  @override
  _MyCustomForm createState() {
    return _MyCustomForm();
  }
}

class _MyCustomForm extends State<MyCustomForm> {
  late final nomeController = TextEditingController(text: nome);
  late final cognomeController = TextEditingController(text: cognome);
  late final azione = TextEditingController(text: azioneToUpdate);
  late final altro = TextEditingController(text: altroToUpdate);
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late Event nuovoEvento;
  String? nome;
  String? cognome;
  String? azioneToUpdate;
  String? altroToUpdate;

  @override
  void initState() {
    nome = widget.eventToUpdate?.nomePaziente;
    cognome = widget.eventToUpdate?.cognomePaziente;
    azioneToUpdate = widget.eventToUpdate?.azione;
    altroToUpdate = widget.eventToUpdate?.altro;
    primaTerapia = 'Terapia/Controlli Clinici';
    fasciaOraria = 'Mattina';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    azione.dispose();
    altro.dispose();
    super.dispose();
  }

  void barratoFunction(bool barra) {
    setState(() {
      widget.eventToUpdate!.barrato = barra;
    });
  }

  void eliminaEvento() {
    Navigator.pop(context, true);
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
                // update part
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
                ), //if(widget.eventToUpdate!=null)
                if (widget.eventToUpdate != null) ...[
                  CheckBoxCustom(
                    isChecked: widget.eventToUpdate!.barrato,
                    barratoFunction: barratoFunction,
                  ),
                  DeleteButton(eliminaFunc: eliminaEvento)
                ],
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _formKey2.currentState!.validate()) {
                      selectedDate ??= widget.initialValue;
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      if (widget.eventToUpdate == null) {
                        widget.eventToUpdate = Event(
                            nomePaziente: nomeController.text.capitalize(),
                            cognomePaziente:
                                cognomeController.text.capitalize(),
                            terapia: primaTerapia,
                            azione: azione.text,
                            data: selectedDate!,
                            fasciaOraria: fasciaOraria,
                            altro: altro.text,
                            barrato: false,
                            cancellato: false);
                      } else {
                        widget.eventToUpdate!.nomePaziente =
                            nomeController.text.capitalize();
                        widget.eventToUpdate!.cognomePaziente =
                            cognomeController.text.capitalize();
                        widget.eventToUpdate!.terapia = primaTerapia;
                        widget.eventToUpdate!.azione = azione.text;
                        widget.eventToUpdate!.data = selectedDate!;
                        widget.eventToUpdate!.fasciaOraria = fasciaOraria;
                        widget.eventToUpdate!.altro = altro.text;
                      }
                      Navigator.pop(context, widget.eventToUpdate);
                    }
                  },
                  child: const Text('Aggiungi'),
                ),
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

class CheckBoxCustom extends StatefulWidget {
  CheckBoxCustom(
      {super.key, required this.isChecked, required this.barratoFunction});
  bool isChecked;
  Function barratoFunction;

  @override
  State<CheckBoxCustom> createState() => _CheckBoxCustomState();
}

class _CheckBoxCustomState extends State<CheckBoxCustom> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Barra senza eliminare l\'elemento'),
      checkColor: Color.fromARGB(255, 255, 255, 255),
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.isChecked,
      onChanged: (bool? value) {
        setState(() {
          widget.isChecked = value!;
          widget.barratoFunction(value);
        });
      },
    );
  }
}

class DeleteButton extends StatefulWidget {
  DeleteButton({super.key, required this.eliminaFunc});
  Function eliminaFunc;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Elimina Evento'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
      onPressed: () {
        showInformationDialog(context);
      },
    );
  }

// A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
  Future<void> showInformationDialog(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await showDialog(
        context: context,
        builder: (context) {
          bool elimina = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Elimina Completamente \nEvento"),
                      Checkbox(
                          value: elimina,
                          onChanged: (checked) {
                            setState(() {
                              elimina = checked!;
                            });
                          }),
                    ],
                  )
                ],
              )),
              actions: <Widget>[
                TextButton(
                  child: Text('Fatto'),
                  onPressed: () {
                    // Do something like updating SharedPreferences or User Settings etc.
                    Navigator.of(context).pop(elimina);
                  },
                ),
              ],
            );
          });
        });
    if (result) {
      widget.eliminaFunc();
    }
  }
}
