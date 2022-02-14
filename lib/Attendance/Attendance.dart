import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    // child: const Icon(
    //   Icons.person,
    //   color: Colors.amber,
    // ),
  );

  _setEvents() {}
  //late EventList<Event> _markedDateMap = [] as EventList<Event>;

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  _iterateThroughDates() {
    for (int i = 1; i < 14; i++) {
      _markedDateMap.add(
        DateTime(2022, 2, i),
        Event(
          date: DateTime(2022, 2, i),
          title: '',
          icon: _eventIcon,
        ),
      );
    }
  }

  CalendarCarousel? _calendarCarouselNoHeader;

  @override
  void initState() {
    _iterateThroughDates();
    super.initState();
  }
  /*
    _markedDateMap.addAll(DateTime.now(), [
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2022, 2, 5),
        title: '',
        icon: _eventIcon,
      ),
    ]);
  */

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.red,
      onDayPressed: (DateTime date, List<Event> events) {
        setState(() => _currentDate2 = date);
        // events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: const TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: MediaQuery.of(context).size.height * 0.82,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      inactiveDaysTextStyle: const TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        _dialogueBox(date);
      },
    );

    return Material(
        child: Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _top(),
            const SizedBox(
              height: 30,
            ),
            _body(),
          ],
        ),
      ),
    ));
  }

  Widget _top() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: const Text(
        'My Attendace',
        style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Container(
            child: _calendarCarouselNoHeader,
          ),
        ));
  }

  _dialogueBox(DateTime date) {
    print(date.toString() + " pressed");
  }
}
