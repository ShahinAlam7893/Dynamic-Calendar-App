// // lib/data/models/availability_model.dart
// import 'package:flutter/material.dart';
// import 'package:circleslate/domain/entities/availability_entity.dart'; // Import entity
//
// enum AvailabilityStatus { available, busy, tentative }
// enum RepeatScheduleType { justOnce, weekly, monthly, custom }
//
// class AvailabilityModel extends AvailabilityEntity {
//   const AvailabilityModel({
//     required String childId,
//     required AvailabilityStatus status,
//     required List<DateTime> selectedDays,
//     required List<TimeOfDay> selectedTimeSlots, // e.g., [TimeOfDay(8,0), TimeOfDay(12,0)]
//     required RepeatScheduleType repeatType,
//     DateTime? customRepeatEndDate,
//   }) : super(
//     childId: childId,
//     status: status,
//     selectedDays: selectedDays,
//     selectedTimeSlots: selectedTimeSlots,
//     repeatType: repeatType,
//     customRepeatEndDate: customRepeatEndDate,
//   );
//
//   factory AvailabilityModel.fromEntity(AvailabilityEntity entity) {
//     return AvailabilityModel(
//       childId: entity.childId,
//       status: entity.status,
//       selectedDays: entity.selectedDays,
//       selectedTimeSlots: entity.selectedTimeSlots,
//       repeatType: entity.repeatType,
//       customRepeatEndDate: entity.customRepeatEndDate,
//     );
//   }
//
//   // Example: Convert to JSON for Firestore (simplified)
//   Map<String, dynamic> toJson() {
//     return {
//       'childId': childId,
//       'status': status.toString().split('.').last, // Convert enum to string
//       'selectedDays': selectedDays.map((d) => d.toIso8601String()).toList(),
//       'selectedTimeSlots': selectedTimeSlots.map((t) => '${t.hour}:${t.minute}').toList(),
//       'repeatType': repeatType.toString().split('.').last,
//       'customRepeatEndDate': customRepeatEndDate?.toIso8601String(),
//     };
//   }
//
//   // Example: Convert from JSON for Firestore (simplified)
//   factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
//     return AvailabilityModel(
//       childId: json['childId'] as String,
//       status: AvailabilityStatus.values.firstWhere(
//               (e) => e.toString().split('.').last == json['status']),
//       selectedDays: (json['selectedDays'] as List<dynamic>)
//           .map((e) => DateTime.parse(e as String))
//           .toList(),
//       selectedTimeSlots: (json['selectedTimeSlots'] as List<dynamic>)
//           .map((e) {
//         final parts = (e as String).split(':');
//         return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
//       })
//           .toList(),
//       repeatType: RepeatScheduleType.values.firstWhere(
//               (e) => e.toString().split('.').last == json['repeatType']),
//       customRepeatEndDate: json['customRepeatEndDate'] != null
//           ? DateTime.parse(json['customRepeatEndDate'] as String)
//           : null,
//     );
//   }
// }