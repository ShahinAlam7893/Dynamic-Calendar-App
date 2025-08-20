// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../core/constants/app_colors.dart';
//
// class EventFormPage extends StatefulWidget {
//   const EventFormPage({super.key});
//
//   @override
//   _EventFormPageState createState() => _EventFormPageState();
// }
//
// class _EventFormPageState extends State<EventFormPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _detailsController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   Future<void> _pickDateTime(bool isStart) async {
//     DateTime now = DateTime.now();
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: DateTime(now.year + 5),
//     );
//
//     if (pickedDate != null) {
//       final pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         final dateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         setState(() {
//           if (isStart) {
//             _startDate = dateTime;
//           } else {
//             _endDate = dateTime;
//           }
//         });
//       }
//     }
//   }
//
//   Future<void> _openGoogleCalendar() async {
//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select start & end date")),
//       );
//       return;
//     }
//
//     if (_endDate!.isBefore(_startDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("End date must be after start date")),
//       );
//       return;
//     }
//
//     final String title = Uri.encodeComponent(
//         _titleController.text.isEmpty ? "Event" : _titleController.text);
//     final String details = Uri.encodeComponent(
//         _detailsController.text.isEmpty ? "Details" : _detailsController.text);
//     final String location = Uri.encodeComponent(
//         _locationController.text.isEmpty ? "Location" : _locationController.text);
//
//     // Format DateTime for Google Calendar: YYYYMMDDTHHMMSS
//     String formatDateTime(DateTime dateTime) {
//       return dateTime.toUtc()
//           .toIso8601String()
//           .replaceAll('-', '')
//           .replaceAll(':', '')
//           .split('.')
//           .first;
//     }
//
//     final String start = formatDateTime(_startDate!);
//     final String end = formatDateTime(_endDate!);
//
//     final Uri url = Uri.parse(
//       "https://calendar.google.com/calendar/u/0/r/eventedit"
//           "?text=$title"
//           "&details=$details"
//           "&location=$location"
//           "&dates=$start/$end",
//     );
//
//     try {
//       if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//         throw 'Could not open Google Calendar';
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error opening Google Calendar: $e")),
//       );
//     }
//   }
//
//   String _formatDisplay(DateTime? dateTime) {
//     if (dateTime == null) return "Pick Date & Time";
//     return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryBlue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         elevation: 0,
//         title: const Text("Add Event to Google Calendar",
//             style: TextStyle(color: Colors.white, fontSize: 20.0)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: "Event Title",
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _detailsController,
//               decoration: InputDecoration(
//                 labelText: "Details",
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: "Location",
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => _pickDateTime(true),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: AppColors.primaryBlue,
//                       backgroundColor: Colors.white,
//                       elevation: 0,
//                       side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("Start: ${_formatDisplay(_startDate)}"),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => _pickDateTime(false),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: AppColors.primaryBlue,
//                       backgroundColor: Colors.white,
//                       elevation: 0,
//                       side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("End: ${_formatDisplay(_endDate)}"),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: const LinearGradient(
//                   colors: [AppColors.lightBlue, AppColors.primaryBlue],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: _openGoogleCalendar,
//                 icon: const Icon(Icons.calendar_today, color: Colors.white),
//                 label: const Text("Add to Google Calendar", style: TextStyle(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.buttonPrimary, // Make button background transparent to show the gradient
//                   shadowColor: Colors.transparent, // Remove button shadow
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
