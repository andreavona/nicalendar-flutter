// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  String nomePaziente;
  String azione;
  DateTime data;
  String fasciaOraria;
  String? altro;

  Event(
      {required this.nomePaziente,
      required this.azione,
      required this.data,
      required this.fasciaOraria,
      this.altro});

  dynamic toJson() => {
        'Nome Paziente': nomePaziente,
        'Azione': azione,
        'Data': DateFormat.yMd().format(data),
        'Fascia Oraria': fasciaOraria,
        'Altro': altro
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

/* final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  }); */

LinkedHashMap<DateTime, List<Event>> _kEventSource =
    LinkedHashMap<DateTime, List<Event>>();

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(1900, 1, 1);
final kLastDay = DateTime(3000, 12, 31);
