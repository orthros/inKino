import 'dart:async';

import 'package:inkino/data/models/event.dart';
import 'package:inkino/data/models/show.dart';
import 'package:inkino/data/models/theater.dart';
import 'package:inkino/utils/http_utils.dart';
import 'package:intl/intl.dart';

class FinnkinoApi {
  static final DateFormat ddMMyyyy = new DateFormat('dd.MM.yyyy');

  static final Uri kScheduleBaseUrl =
      new Uri.https('www.finnkino.fi', '/en/xml/Schedule');
  static final Uri kEventsBaseUrl =
      new Uri.https('www.finnkino.fi', '/en/xml/Events');

  Future<List<Show>> getSchedule(Theater theater, DateTime date) async {
    var dt = ddMMyyyy.format(date ?? new DateTime.now());
    var response = await getRequest(
      kScheduleBaseUrl.replace(queryParameters: {
        'area': theater.id,
        'dt': dt,
      }),
    );

    return Show.parseAll(response);
  }

  Future<List<Event>> getNowInTheatersEvents(Theater theater) async {
    var response = await getRequest(
      kEventsBaseUrl.replace(queryParameters: {
        'area': theater.id,
        'listType': 'NowInTheatres',
      }),
    );

    return Event.parseAll(response);
  }

  Future<List<Event>> getUpcomingEvents() async {
    var response = await getRequest(
      kEventsBaseUrl.replace(queryParameters: {
        'listType': 'ComingSoon',
      }),
    );

    return Event.parseAll(response);
  }
}
