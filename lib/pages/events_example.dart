// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'new_event.dart';

import '../utils.dart';
import '../lib_table_calendar/table_calendar.dart';

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late ValueNotifier<List<Event>> _selectedEventsMattina;
  late ValueNotifier<List<Event>> _selectedEventsPomeriggio;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEventsMattina =
        ValueNotifier(_getEventsForDay(_selectedDay!, 'Mattina'));
    _selectedEventsPomeriggio =
        ValueNotifier(_getEventsForDay(_selectedDay!, 'Pomeriggio'));
  }

  @override
  void dispose() {
    _selectedEventsMattina.dispose();
    _selectedEventsPomeriggio.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day, String fasciaOraria) {
    // Implementation example
    if (fasciaOraria != null || fasciaOraria != '') {
      return kEvents[day]
              ?.where((element) => element.fasciaOraria == fasciaOraria)
              .toList() ??
          [];
    } else {
      return kEvents[day] ?? [];
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEventsMattina.value = _getEventsForDay(selectedDay, 'Mattina');
      _selectedEventsPomeriggio.value =
          _getEventsForDay(selectedDay, 'Pomeriggio');
    }
  }

  void refresh() {
    setState(() {
      _selectedEventsMattina.value = _getEventsForDay(_selectedDay!, 'Mattina');
      _selectedEventsPomeriggio.value =
          _getEventsForDay(_selectedDay!, 'Pomeriggio');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SelectionButton(
              initialDate: _focusedDay,
              notifyParent: refresh), // pulsante aggiungi eventi
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEventsMattina,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ExpansionTile(
                          //title: Text('${value[index].nomePaziente}'),
                          title: RichText(
                            text: TextSpan(
                              text: '',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${value[index].nomePaziente} ${value[index].cognomePaziente}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: value[index].barrato,
                                    )),
                              ],
                            ),
                          ),
                          subtitle: Text('${value[index].terapia}'),
                          controlAffinity: ListTileControlAffinity.leading,
                          trailing: DeleteButton(
                              evento: value[index],
                              dates: _selectedEventsMattina.value),
                          children: <Widget>[
                            ListTile(
                                title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Azione Richiesta: ${value[index].azione}'),
                                Text('Orario: ${value[index].fasciaOraria}'),
                                Text('Altro: ${value[index].altro}')
                              ],
                            )),
                          ],
                        ));
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEventsPomeriggio,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ExpansionTile(
                          //title: Text('${value[index].nomePaziente}'),
                          title: RichText(
                            text: TextSpan(
                              text: '',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${value[index].nomePaziente} ${value[index].cognomePaziente}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: value[index].barrato,
                                    )),
                              ],
                            ),
                          ),
                          subtitle: Text('${value[index].terapia}'),
                          controlAffinity: ListTileControlAffinity.leading,
                          trailing: DeleteButton(
                              evento: value[index],
                              dates: _selectedEventsPomeriggio.value),
                          children: <Widget>[
                            ListTile(
                                title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Azione Richiesta: ${value[index].azione}'),
                                Text('Orario: ${value[index].fasciaOraria}'),
                                Text('Altro: ${value[index].altro}')
                              ],
                            )),
                          ],
                        ));
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SelectionButton extends StatefulWidget {
  const SelectionButton(
      {super.key, required this.initialDate, required this.notifyParent});
  final DateTime initialDate;
  final Function() notifyParent;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }

// A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyCustomForm(initialValue: widget.initialDate)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result != null) {
      //setState(() {});
      //kEvents[result.data] = result;
      if (kEvents[result.data] == null) {
        final growableList = <Event>[];
        kEvents[result.data] = growableList;
      }
      kEvents[result.data]!.add(result);
      widget.notifyParent();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }
}

class DeleteButton extends StatefulWidget {
  DeleteButton({super.key, required this.evento, required this.dates});
  Event evento;
  List<Event> dates;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Cancella o Elimina Evento',
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
          bool barra = false;
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
                      Text("Barra Evento"),
                      Checkbox(
                          value: barra,
                          onChanged: (checked) {
                            setState(() {
                              barra = checked!;
                            });
                          }),
                    ],
                  ),
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
                  child: Text('Okay'),
                  onPressed: () {
                    List<bool> decision = [barra, elimina];
                    // Do something like updating SharedPreferences or User Settings etc.
                    Navigator.of(context).pop(decision);
                  },
                ),
              ],
            );
          });
        });

    if (result[1]) {
      widget.dates.removeWhere(
          (item) => item.nomePaziente == widget.evento.nomePaziente);
    } else if (result[0]) {
      widget.evento.barrato = TextDecoration.lineThrough;
    } else {
      widget.evento.barrato = TextDecoration.none;
    }
  }
}
