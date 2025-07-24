// lib/presentation/features/calendar/view/calendar_screen.dart
import 'package:circleslate/core/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 31,
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(2025, 7, day);
          final state = calendarProvider.getStateForDate(date);
          final key = "${date.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

          Color color;
          switch (state) {
            case 1:
              color = Colors.green;
              break;
            case 2:
              color = Colors.yellow;
              break;
            case 3:
              color = Colors.red;
              break;
            default:
              color = Colors.grey;
          }

          return GestureDetector(
            onTap: () {
              int newState = (state % 3) + 1; // Cycle through 1 → 2 → 3 → 1
              calendarProvider.updateCalendarDateState(date, newState);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("$day", style: const TextStyle(fontSize: 16)),
            ),
          );
        },
      ),
    );
  }
}
