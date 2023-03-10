// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/events_example.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';

//import 'package:flutter_gen/gen_l10n/gallery_localizations.dart'; //desired one

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NiCalendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Calendario'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Pagina Admin'),
              onPressed: () {},
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Ricerca Evento'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
