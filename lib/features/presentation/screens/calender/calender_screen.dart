import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "التقويم الميلادي والهجري", isLeading: false),
      body: Column(
        children: [
          CupertinoSegmentedControl<int>(
            children: const {
              0: Text('التقويم الميلادي'),
              1: Text('التقويم الهجري'),
            },
            onValueChanged: (int value) => setState(() => _selectedIndex = value),
            groupValue: _selectedIndex,
          ),
          Expanded(child: _selectedIndex == 0 ? _buildGeorgianCalendar() : _buildHijriCalendar()),
        ],
      ),
    );
  }

  Widget _buildGeorgianCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  // Widget _buildHijriCalendar() {
  //   HijriCalendar today = HijriCalendar.now();
  //   return ListView.builder(
  //     itemCount: 12,
  //     itemBuilder: (context, index) {
  //       HijriCalendar month = HijriCalendar.fromDate(DateTime(today.hYear, index + 1, 1));
  //       return ExpansionTile(
  //         title: Text('${month.longMonthName} ${month.hYear}'),
  //         children: List.generate(month.lengthOfMonth, (day) {
  //           HijriCalendar date = HijriCalendar.fromDate(DateTime(today.hYear, index + 1, day + 1));
  //           return ListTile(
  //             title: Text('${date.hDay} ${date.longMonthName} ${date.hYear}'),
  //             subtitle: Text('${date.weekDay}'),
  //           );
  //         }),
  //       );
  //     },
  //   );
  // }
  Widget _buildHijriCalendar() {
    HijriCalendar today = HijriCalendar.now();
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        // HijriCalendar month = HijriCalendar.fromDate(DateTime(year, index + 1, 1));
        var month = HijriCalendar.fromDate(DateTime(2018, 11, 12));

        return ExpansionTile(
          title: Text('${month.longMonthName} ${month.hYear}'),
          children: List.generate(month.lengthOfMonth, (day) {
            HijriCalendar date = HijriCalendar.now();
            return ListTile(
              title: Text('${date.hDay} ${date.longMonthName} ${date.hYear}'),
              subtitle: Text('${date.weekDay}'),
            );
          }),
        );
      },
    );
  }
}