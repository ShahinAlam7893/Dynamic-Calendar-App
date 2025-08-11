class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String startTime;
  final String endTime;
  final String location;
  final String eventType;
  final String eventTypeDisplay;
  final Host host;
  final bool rideNeededForEvent;
  final List<Response> responses;
  final int goingCount;
  final int notGoingCount;
  final int pendingCount;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.eventType,
    required this.eventTypeDisplay,
    required this.host,
    required this.rideNeededForEvent,
    required this.responses,
    required this.goingCount,
    required this.notGoingCount,
    required this.pendingCount,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var responsesList = json['responses'] as List? ?? [];
    List<Response> responses = responsesList
        .map((i) => Response.fromJson(i))
        .toList();

    String timeRange = '';
    if (json['start_time'] != null && json['end_time'] != null) {
      timeRange = "${json['start_time']} - ${json['end_time']}";
    }

    String statusText = json['ride_needed_for_event'] == true
        ? "Ride Needed"
        : (json['event_type_display'] ?? "Open");

    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: timeRange,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      location: json['location'] ?? '',
      eventType: json['event_type'] ?? '',
      eventTypeDisplay: json['event_type_display'] ?? '',
      host: json['host'] != null
          ? Host.fromJson(json['host'])
          : Host(id: '', email: '', fullName: ''),
      rideNeededForEvent: json['ride_needed_for_event'] ?? false,
      responses: responses,
      goingCount: json['going_count'] ?? 0,
      notGoingCount: json['not_going_count'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      status: statusText,
    );
  }
}

class Host {
  final String id;
  final String email;
  final String fullName;

  Host({required this.id, required this.email, required this.fullName});

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
    );
  }
}

class Response {
  final String id;
  final String userId;
  final String response;
  final String responseDisplay;

  Response({
    required this.id,
    required this.userId,
    required this.response,
    required this.responseDisplay,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      id: json['id']?.toString() ?? '',
      userId: json['user'] != null ? json['user']['id']?.toString() ?? '' : '',
      response: json['response']?.toString() ?? '',
      responseDisplay: json['response_display']?.toString() ?? '',
    );
  }
}
