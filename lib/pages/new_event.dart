import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_f/src/field.dart';
import '../date_f/src/form_field.dart';

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;

    return Scaffold(
        appBar: AppBar(
          title: Text('Nuovo Evento'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nome Paziente',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Tipo di Azione',
                ),
              ),
            ),
            /*DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Only time',
                ),
                mode: DateTimeFieldPickerMode.time,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  print(value);
                },
              ), */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                      //firstDate: DateTime.now().add(const Duration(days: 10)),
                      //lastDate: DateTime.now().add(const Duration(days: 40)),
                      //initialDate: DateTime.now().add(const Duration(days: 20)),
                      autovalidateMode: AutovalidateMode.always,
                      /*validator: (DateTime? e) =>
                            (e?.day ?? 0) == 1 ? 'Please not the first day' : null,*/
                      onDateSelected: (DateTime value) {
                        //print(DateFormat.yMMMd().format(DateTime.now()));
                        print(DateFormat.yMd().format(value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Altro',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Nuovo Evento Aggiunto!');
              },
              child: const Text('Crea'),
            )
          ],
        )));
  }
}
