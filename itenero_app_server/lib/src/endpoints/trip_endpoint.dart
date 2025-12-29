import 'dart:convert';

import 'package:googleai_dart/googleai_dart.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_client.dart';

class TripEndpoint extends Endpoint {
  Future<Trip> createTrip(
      Session session, {
        required String destination,
        required int daysCount,
        required String focus,
        required String travelersType,
        String? budget,
      }) async {
    final now = DateTime.now();

    final trip = Trip(
      destination: destination,
      daysCount: daysCount,
      focus: focus,
      travelersType: travelersType,
      budget: budget,
      createdAt: now,
    );

    final inserted = await Trip.db.insertRow(session, trip);
    return inserted;
  }

  Future<List<Trip>> listTrips(Session session) async {
    return Trip.db.find(session);
  }

  Future<Trip> generateItinerary(
      Session session, {
        required int tripId,
        required String userDescription,
      }) async {
    // 1. Load the trip
    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      throw ArgumentError('Trip not found');
    }

    // 2. Build prompt
    final prompt = _buildItineraryPrompt(trip, userDescription);

    // 3. Call Gemini
    final client = createGeminiClient(session);

    final response = await client.models.generateContent(
      model: 'gemini-1.5-flash',
      request: GenerateContentRequest(
        contents: [
          Content.text(prompt),
        ],
      ),
    );

    final jsonText = response.text;
    if (jsonText == null) {
      throw StateError('Gemini returned no text');
    }

    final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
    final days = decoded['days'] as List<dynamic>? ?? [];

    // 4. Clear existing plan for this trip (if regenerating)
    final existingDays = await TripDay.db.find(
      session,
      where: (t) => t.tripId.equals(tripId),
    );

    if (existingDays.isNotEmpty) {
      await Activity.db.deleteWhere(
        session,
        where: (a) => a.tripDayId.inSet(
          existingDays.map((d) => d.id!).toSet(),
        ),
      );
      await TripDay.db.deleteWhere(
        session,
        where: (t) => t.tripId.equals(tripId),
      );
    }

    // 5. Insert new TripDay + Activity rows
    var dayIndex = 1;
    for (final day in days) {
      final dayMap = day as Map<String, dynamic>;

      final tripDay = TripDay(
        tripId: tripId,
        dayIndex: dayIndex++,
        date: _parseNullableDate(dayMap['date']),
        summary: dayMap['summary'] as String?,
      );

      final insertedDay = await TripDay.db.insertRow(session, tripDay);

      final activities = dayMap['activities'] as List<dynamic>? ?? [];
      for (final rawActivity in activities) {
        final a = rawActivity as Map<String, dynamic>;

        final lat = (a['lat'] as num?)?.toDouble();
        final lon = (a['lon'] as num?)?.toDouble();
        double? safeLat;
        double? safeLon;
        if (lat != null && lon != null && lat.abs() <= 90 && lon.abs() <= 180) {
          safeLat = lat;
          safeLon = lon;
        }

        final category = (a['category'] as String?) ?? 'activity';
        final normalizedCategory = [
          'hotel',
          'sightseeing',
          'food',
          'airport',
          'transport',
          'activity',
        ].contains(category)
            ? category
            : 'activity';

        final activity = Activity(
          tripDayId: insertedDay.id!,
          title: a['title'] as String,
          description: (a['description'] as String?) ?? '',
          category: normalizedCategory,
          startTime: _parseNullableDateTime(a['startTime']),
          endTime: _parseNullableDateTime(a['endTime']),
          locationName: a['locationName'] as String?,
          lat: safeLat,
          lon: safeLon,
          estimatedCost: (a['estimatedCost'] as num?)?.toDouble(),
        );


        await Activity.db.insertRow(session, activity);
      }
    }

    // 6. Return trip (client will call another endpoint to fetch full plan)
    return trip;
  }

  String _buildItineraryPrompt(Trip trip, String userDescription) {
    return '''
You are a travel planning assistant.

Create a detailed ${trip.daysCount}-day itinerary for:
Destination: ${trip.destination}
Focus: ${trip.focus}
Travellers: ${trip.travelersType}
Budget: ${trip.budget ?? 'not specified'}

User extra description:
"$userDescription"

Requirements:
- Suggest one sensible hotel for the entire stay.
- Each day must include: breakfast, 2–3 main activities, lunch, dinner, and some free time.
- Use time slots with rough start and end times.
- Make activities match the focus (adventure, nature, historical, modern, etc.).
- The last day must end with going to the airport for the return flight.
- Use simple, friendly language.

For every activity, if you know the approximate location, include realistic latitude and longitude for the destination city. 
If you don't know, set both "lat" and "lon" to null.

Allowed categories:
- "hotel"
- "sightseeing"
- "food"
- "airport"
- "transport"
- "activity"

Respond ONLY as strict JSON with this structure:

{
  "days": [
    {
      "date": "2025-06-01",  // or null
      "summary": "Short summary of the day",
      "activities": [
        {
          "title": "Check in at Hotel XYZ",
          "description": "Short description.",
          "category": "hotel | sightseeing | food | airport | transport | activity",
          "startTime": "2025-06-01T14:00:00",
          "endTime": "2025-06-01T15:00:00",
          "locationName": "Hotel XYZ, City",
          "lat": 25.2854,
          "lon": 51.5310,
          "estimatedCost": 100.0
        }
      ]
    }
  ]
}
''';
  }

  DateTime? _parseNullableDate(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Future<TripWithPlan> getTripWithPlan(
      Session session, {
        required int tripId,
      }) async {
    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      throw ArgumentError('Trip not found');
    }

    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
      orderBy: (d) => d.dayIndex,
    );

    final dayIds = days.map((d) => d.id!).toSet();

    final activities = await Activity.db.find(
      session,
      where: (a) => a.tripDayId.inSet(dayIds),
    );

    return TripWithPlan(
      trip: trip,
      days: days,
      activities: activities,
    );
  }

  Future<List<Activity>> getActivitiesForTrip(
      Session session, {
        required int tripId,
      }) async {
    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
    );
    if (days.isEmpty) return [];

    final dayIds = days.map((d) => d.id!).toSet();

    return Activity.db.find(
      session,
      where: (a) => a.tripDayId.inSet(dayIds),
    );
  }

  Future<List<Reminder>> getUpcomingActivities(
      Session session, {
        required int tripId,
      }) async {
    final now = DateTime.now().toUtc();
    final next24 = now.add(const Duration(hours: 24));

    // Find all days for this trip
    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
    );
    if (days.isEmpty) return [];

    final dayIds = days.map((d) => d.id!).toSet();

    // Find activities with startTime in [now, now + 24h]
    final activities = await Activity.db.find(
      session,
      where: (a) =>
      a.tripDayId.inSet(dayIds) &
      a.startTime.notEquals(null) &
      (a.startTime >= now) &
      (a.startTime <= next24),
      orderBy: (a) => a.startTime,
    );

    // Map TripDay ids to index for better messages
    final dayIndexById = {
      for (final d in days) d.id!: d.dayIndex,
    };

    final reminders = <Reminder>[];

    for (final a in activities) {
      final dayIndex = dayIndexById[a.tripDayId] ?? 0;
      final when = a.startTime;

      final message = _buildReminderMessage(a, dayIndex, when);

      reminders.add(
        Reminder(
          activityId: a.id!,
          tripId: tripId,
          tripDayId: a.tripDayId,
          title: a.title,
          message: message,
          startTime: when,
        ),
      );
    }

    return reminders;
  }

  String _buildReminderMessage(
      Activity activity,
      int dayIndex,
      DateTime? when,
      ) {
    final timePart = when != null
        ? 'at ${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}'
        : '';

    switch (activity.category) {
      case 'hotel':
        return 'Day $dayIndex: Time to check in at ${activity.locationName ?? activity.title} $timePart.';
      case 'food':
        return 'Day $dayIndex: Don\'t miss your meal at ${activity.locationName ?? activity.title} $timePart.';
      case 'airport':
        return 'Day $dayIndex: Head to the airport for your flight $timePart.';
      case 'sightseeing':
        return 'Day $dayIndex: Get ready to explore ${activity.locationName ?? activity.title} $timePart.';
      default:
        return 'Day $dayIndex: Upcoming activity ${activity.title} $timePart.';
    }
  }

  Future<DayBriefing> generateDaySummary(
      Session session, {
        required int tripId,
        required int dayIndex,
      }) async {
    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      throw ArgumentError('Trip not found');
    }

    final day = await TripDay.db.findFirstRow(
      session,
      where: (d) =>
      d.tripId.equals(tripId) &
      d.dayIndex.equals(dayIndex),
    );
    if (day == null) {
      throw ArgumentError('Day $dayIndex not found for trip');
    }

    final activities = await Activity.db.find(
      session,
      where: (a) => a.tripDayId.equals(day.id!),
      orderBy: (a) => a.startTime,
    );

    final client = createGeminiClient(session);

    final prompt = _buildDaySummaryPrompt(trip, day, activities);

    final response = await client.models.generateContent(
      model: 'gemini-3.5-flash',
      request: GenerateContentRequest(
        contents: [Content.text(prompt)],
        // plain text is fine here
      ),
    );

    final text = response.text ?? 'No summary available today.';

    // Optionally store into TripDay.summary
    day.summary = text;
    await TripDay.db.updateRow(session, day);

    return DayBriefing(
      tripId: tripId,
      tripDayId: day.id!,
      dayIndex: day.dayIndex,
      summary: text,
    );
  }

  String _buildDaySummaryPrompt(
      Trip trip,
      TripDay day,
      List<Activity> activities,
      ) {
    final buffer = StringBuffer();

    buffer.writeln('You are a friendly travel assistant.');
    buffer.writeln(
        'Create a concise, motivational morning briefing for a traveler.');
    buffer.writeln('');
    buffer.writeln('Destination: ${trip.destination}');
    buffer.writeln('Trip focus: ${trip.focus}');
    buffer.writeln('Travelers: ${trip.travelersType}');
    buffer.writeln('Budget: ${trip.budget ?? 'not specified'}');
    buffer.writeln('Day number: ${day.dayIndex}');
    if (day.date != null) {
      buffer.writeln('Date: ${day.date}');
    }
    buffer.writeln('');
    buffer.writeln('Planned activities for this day:');

    for (final a in activities) {
      final timePart = a.startTime != null
          ? '${a.startTime!.hour.toString().padLeft(2, '0')}:${a.startTime!.minute.toString().padLeft(2, '0')}'
          : 'time flexible';
      buffer.writeln(
          '- [$timePart] ${a.title} (${a.category}) at ${a.locationName ?? 'N/A'}');
    }

    buffer.writeln('');
    buffer.writeln(
        'Write in 2–3 short, friendly sentences. Mention the main highlights,');
    buffer.writeln(
        'and add one small tip (e.g., bring water, arrive early, wear comfortable shoes).');
    buffer.writeln('Do NOT list the activities again as bullets.');
    buffer.writeln('Just respond with the briefing text, nothing else.');

    return buffer.toString();
  }





}
