// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:provider/provider.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../presentation/common_providers/availability_provider.dart';
// import '../../../presentation/common_providers/user_events_provider.dart'; // Import UserEventsProvider
//
// class CalendarPart extends StatefulWidget {
//   const CalendarPart({Key? key}) : super(key: key);
//
//   @override
//   State<CalendarPart> createState() => _CalendarPartState();
// }
//
// class _CalendarPartState extends State<CalendarPart> {
//   int _currentMonth = DateTime.now().month;
//   int _currentYear = DateTime.now().year;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AvailabilityProvider>(context, listen: false)
//           .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
//       Provider.of<UserEventsProvider>(context, listen: false)
//           .fetchGoingEvents(context); // Pass context
//     });
//   }
//
//   void _goToNextMonth() {
//     setState(() {
//       if (_currentMonth == 12) {
//         _currentMonth = 1;
//         _currentYear++;
//       } else {
//         _currentMonth++;
//       }
//     });
//     Provider.of<AvailabilityProvider>(context, listen: false)
//         .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
//     Provider.of<UserEventsProvider>(context, listen: false)
//         .fetchGoingEvents(context); // Pass context
//   }
//
//   void _goToPreviousMonth() {
//     setState(() {
//       if (_currentMonth == 1) {
//         _currentMonth = 12;
//         _currentYear--;
//       } else {
//         _currentMonth--;
//       }
//     });
//     Provider.of<AvailabilityProvider>(context, listen: false)
//         .fetchMonthAvailabilityFromAPI(_currentYear, _currentMonth);
//     Provider.of<UserEventsProvider>(context, listen: false)
//         .fetchGoingEvents(context); // Pass context
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AvailabilityProvider>(context);
//     final userEventsProvider = Provider.of<UserEventsProvider>(context);
//
//     // Generate calendar dates
//     final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
//     final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
//     final startDayOffset = firstDayOfMonth.weekday % 7;
//
//     List<DateTime> calendarDates = [];
//
//     // Previous month days
//     for (int i = 0; i < startDayOffset; i++) {
//       calendarDates.add(
//           firstDayOfMonth.subtract(Duration(days: startDayOffset - i)));
//     }
//
//     // Current month days
//     for (int i = 1; i <= daysInMonth; i++) {
//       calendarDates.add(DateTime(_currentYear, _currentMonth, i));
//     }
//
//     // Next month days
//     while (calendarDates.length % 7 != 0) {
//       final lastDate = calendarDates.last;
//       calendarDates.add(lastDate.add(const Duration(days: 1)));
//     }
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final double weekdayFontSize = screenWidth * 0.035;
//     final double dateNumberFontSize = screenWidth * 0.04;
//     final double cellSpacing = screenWidth * 0.01;
//     final double borderRadius = screenWidth * 0.02;
//
//     final List<String> weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
//
//     return Column(
//       children: [
//         // Month navigation
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: _goToPreviousMonth,
//             ),
//             Text(
//               '${DateTime(_currentYear, _currentMonth).monthName} $_currentYear',
//               style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: _goToNextMonth,
//             ),
//           ],
//         ),
//         SizedBox(height: screenWidth * 0.02),
//
//         // Weekday labels
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1.0,
//             crossAxisSpacing: cellSpacing,
//             mainAxisSpacing: cellSpacing,
//           ),
//           itemCount: weekdays.length,
//           itemBuilder: (context, index) {
//             return Center(
//               child: Text(
//                 weekdays[index],
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: weekdayFontSize,
//                   color: AppColors.textColorPrimary,
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: screenWidth * 0.02),
//
//         // Calendar grid
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             childAspectRatio: 1.0,
//             crossAxisSpacing: cellSpacing,
//             mainAxisSpacing: cellSpacing,
//           ),
//           itemCount: calendarDates.length,
//           itemBuilder: (context, index) {
//             final date = calendarDates[index];
//             final bool isCurrentMonth =
//                 date.month == _currentMonth && date.year == _currentYear;
//             final formattedDate = DateFormat('yyyy-MM-dd').format(date);
//
//             final state = isCurrentMonth
//                 ? provider.calendarDateStates[date.day] ?? 2
//                 : 2;
//
//             Color bgColor;
//             Color textColor;
//             Color borderColor = Colors.transparent; // Default border color
//
//             if (isCurrentMonth) {
//               switch (state) {
//                 case 0:
//                   bgColor = AppColors.unavailableRed;
//                   textColor = Colors.white;
//                   borderColor = AppColors.unavailableRed;
//                   break;
//                 case 1:
//                   bgColor = AppColors.availableGreen;
//                   textColor = Colors.white;
//                   borderColor = AppColors.availableGreen;
//                   break;
//                 default:
//                   bgColor = AppColors.dateBackground;
//                   textColor = AppColors.dateText;
//                   borderColor = AppColors.dateBackground;
//                   break;
//               }
//             } else {
//               bgColor = AppColors.dateBackground.withOpacity(0.5);
//               textColor = AppColors.dateText.withOpacity(0.5);
//               borderColor = AppColors.dateBackground.withOpacity(0.5);
//             }
//
//             final hasGoingEvent = userEventsProvider.goingEventDates.contains(formattedDate);
//
//             return GestureDetector(
//               onTap: isCurrentMonth
//                   ? () {
//                 provider.toggleDateState(date.day);
//               }
//                   : null,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: bgColor,
//                       border: Border.all(color: borderColor, width: 1.5),
//                       borderRadius: BorderRadius.circular(borderRadius),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${date.day}',
//                         style: TextStyle(
//                           color: textColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: dateNumberFontSize,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (hasGoingEvent && isCurrentMonth)
//                     Positioned(
//                       bottom: screenWidth * 0.005,
//                       right: screenWidth * 0.005,
//                       child: Icon(
//                         Icons.bookmark_add,
//                         size: screenWidth * 0.05,
//                         color: AppColors.primaryBlue, // Consistent with app theme
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
// }
//
// extension MonthName on DateTime {
//   String get monthName {
//     const months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return months[month - 1];
//   }
// }




import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../presentation/common_providers/availability_provider.dart';
import '../../../presentation/common_providers/user_events_provider.dart'; // Import UserEventsProvider

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
      Provider.of<UserEventsProvider>(context, listen: false)
          .fetchGoingEvents(context); // Pass context
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
    Provider.of<UserEventsProvider>(context, listen: false)
        .fetchGoingEvents(context); // Pass context
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
    Provider.of<UserEventsProvider>(context, listen: false)
        .fetchGoingEvents(context); // Pass context
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AvailabilityProvider>(context);
    final userEventsProvider = Provider.of<UserEventsProvider>(context);

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
            final formattedDate = DateFormat('yyyy-MM-dd').format(date);

            final state = isCurrentMonth
                ? provider.calendarDateStates[date.day] ?? 2
                : 2;

            Color bgColor;
            Color textColor;
            Color borderColor = Colors.transparent; // Default border color
            Color? blobColor; // Color for the availability blob

            if (isCurrentMonth) {
              switch (state) {
                case 0: // Unavailable
                  blobColor = AppColors.unavailableRed;
                  textColor = AppColors.dateText;
                  borderColor = AppColors.dateBackground;
                  break;
                case 1: // Available
                  blobColor = AppColors.availableGreen;
                  textColor = AppColors.dateText;
                  borderColor = AppColors.dateBackground;
                  break;
                default: // No availability set
                  blobColor = null; // No blob for default state
                  textColor = AppColors.dateText;
                  borderColor = AppColors.dateBackground;
                  break;
              }
              bgColor = AppColors.dateBackground; // Always use default background for current month
            } else {
              bgColor = AppColors.dateBackground.withOpacity(0.5);
              textColor = AppColors.dateText.withOpacity(0.5);
              borderColor = AppColors.dateBackground.withOpacity(0.5);
              blobColor = null; // No blob for non-current months
            }

            final hasGoingEvent = userEventsProvider.goingEventDates.contains(formattedDate);

            return GestureDetector(
              onTap: isCurrentMonth
                  ? () {
                provider.toggleDateState(date.day);
              }
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor, width: 1.5),
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
                  if (blobColor != null && isCurrentMonth)
                    Positioned(
                      top: screenWidth * 0.005,
                      left: screenWidth * 0.005,
                      child: Container(
                        width: screenWidth * 0.02, // Small blob size
                        height: screenWidth * 0.02,
                        decoration: BoxDecoration(
                          color: blobColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (hasGoingEvent && isCurrentMonth)
                    Positioned(
                      bottom: screenWidth * 0.005,
                      right: screenWidth * 0.005,
                      child: Icon(
                        Icons.bookmark_add,
                        size: screenWidth * 0.05,
                        color: AppColors.primaryBlue, // Consistent with app theme
                      ),
                    ),
                ],
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