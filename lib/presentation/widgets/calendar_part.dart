import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../presentation/common_providers/availability_provider.dart';

class CalendarPart extends StatefulWidget {
  const CalendarPart({Key? key}) : super(key: key);

  @override
  State<CalendarPart> createState() => _CalendarPartState();
}

class _CalendarPartState extends State<CalendarPart> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AvailabilityProvider>(context, listen: false)
          .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
    Provider.of<AvailabilityProvider>(context, listen: false)
        .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
    Provider.of<AvailabilityProvider>(context, listen: false)
        .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AvailabilityProvider>(context);

    // Generate calendar dates
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    final startDayOffset = firstDayOfMonth.weekday % 7;

    List<DateTime> calendarDates = [];

    // Previous month days
    for (int i = 0; i < startDayOffset; i++) {
      calendarDates.add(
          firstDayOfMonth.subtract(Duration(days: startDayOffset - i)));
    }

    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDates.add(DateTime(_currentYear, _currentMonth, i));
    }

    // Next month days
    while (calendarDates.length % 7 != 0) {
      final lastDate = calendarDates.last;
      calendarDates.add(lastDate.add(const Duration(days: 1)));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final double weekdayFontSize = screenWidth * 0.035;
    final double dateNumberFontSize = screenWidth * 0.04;
    final double cellSpacing = screenWidth * 0.01;
    final double borderRadius = screenWidth * 0.02;

    final List<String> weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _goToPreviousMonth,
            ),
            Text(
              '${DateTime(_currentYear, _currentMonth).monthName} $_currentYear',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.02),

        // Weekday labels
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: cellSpacing,
            mainAxisSpacing: cellSpacing,
          ),
          itemCount: weekdays.length,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                weekdays[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: weekdayFontSize,
                  color: AppColors.textColorPrimary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: screenWidth * 0.02),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: cellSpacing,
            mainAxisSpacing: cellSpacing,
          ),
          itemCount: calendarDates.length,
          itemBuilder: (context, index) {
            final date = calendarDates[index];
            final bool isCurrentMonth =
                date.month == _currentMonth && date.year == _currentYear;

            final state = isCurrentMonth
                ? provider.calendarDateStates[date.day] ?? 2
                : 2;

            Color bgColor;
            Color textColor;

            if (isCurrentMonth) {
              switch (state) {
                case 0:
                  bgColor = AppColors.unavailableRed;
                  textColor = Colors.white;
                  break;
                case 1:
                  bgColor = AppColors.availableGreen;
                  textColor = Colors.white;
                  break;
                default:
                  bgColor = AppColors.dateBackground;
                  textColor = AppColors.dateText;
                  break;
              }
            } else {
              bgColor = AppColors.dateBackground.withOpacity(0.5);
              textColor = AppColors.dateText.withOpacity(0.5);
            }

            return GestureDetector(
              onTap: isCurrentMonth
                  ? () {
                provider.toggleDateState(date.day);
              }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: dateNumberFontSize,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

extension MonthName on DateTime {
  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
