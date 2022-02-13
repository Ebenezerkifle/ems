import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({Key? key}) : super(key: key);

  @override
  _CalendarGridState createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  final DateTime _selectedDate = DateTime.now();

  int _selectedIndex = 0;
  late int indexOfFirstDayMonth;

  @override
  void initState() {
    super.initState();
    indexOfFirstDayMonth = getIndexOfFirstDayInMonth(_selectedDate);
    setState(() {
      _selectedIndex = indexOfFirstDayMonth +
          int.parse(DateFormat('d').format(DateTime.now())) -
          1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        /* leading: const Icon(
          Icons.arrow_back,
          color: Colors.indigo,
        ), */
        /* actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.indigo,
            ),
          )
        ], */
        title: Column(
          children: [
            const Text(
              "Calendar",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.indigo),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.grey),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: daysOfWeek.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      daysOfWeek[index],
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0.1,
                    blurRadius: 7,
                    offset: const Offset(0, 7.75),
                  ),
                ]),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: listOfDatesInMonth(_selectedDate).length +
                  indexOfFirstDayMonth,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () => index >= indexOfFirstDayMonth
                        ? setState(() {
                            _selectedIndex = index;
                          })
                        : null,
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: index == _selectedIndex
                                ? Colors.indigo
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50)),
                        foregroundDecoration: BoxDecoration(
                            color: index == _selectedIndex - 3 ||
                                    index == _selectedIndex - 8
                                ? Colors.red
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50)),
                        child: index < indexOfFirstDayMonth
                            ? const Text("")
                            : Text(
                                '${index + 1 - indexOfFirstDayMonth}',
                                style: TextStyle(
                                    color: index == _selectedIndex
                                        ? Colors.white
                                        : index % 7 == 5 || index % 7 == 6
                                            ? Colors.indigo
                                            : Colors.black,
                                    fontSize: 17),
                              )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          /* Expanded(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Image.asset(
                    'assets/images/calendar-icon.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const Text("No events today",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
              ],
            ),
          ), */
        ],
      ),
    );
  }
}

List<int> listOfDatesInMonth(DateTime currentDate) {
  var selectedMonthFirstDay =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  var nextMonthFirstDay = DateTime(selectedMonthFirstDay.year,
      selectedMonthFirstDay.month + 1, selectedMonthFirstDay.day);
  var totalDays = nextMonthFirstDay.difference(selectedMonthFirstDay).inDays;

  var listOfDates = List<int>.generate(totalDays, (i) => i + 1);
  return (listOfDates);
}

int getIndexOfFirstDayInMonth(DateTime currentDate) {
  var selectedMonthFirstDay =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  var day = DateFormat('EEE').format(selectedMonthFirstDay).toUpperCase();

  return daysOfWeek.indexOf(day) - 1;
}

final List<String> daysOfWeek = [
  "MON",
  "TUE",
  "WED",
  "THU",
  "FRI",
  "SAT",
  "SUN",
];
