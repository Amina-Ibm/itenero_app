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
    required DateTime startDate,
    required DateTime endDate,
    required double latitude,
    required double longitude,
    String? originAddress,
    double? originLat,
    double? originLon,
  }) async {
    print('\n========================================');
    print('🚀 CREATE TRIP STARTED');
    print('========================================');
    print('📍 Destination: $destination');
    print('📅 Days: $daysCount');
    print('🎯 Focus: $focus');
    print('👥 Travelers: $travelersType');
    print('💰 Budget: ${budget ?? 'Not specified'}');
    print('📆 Start: $startDate');
    print('📆 End: $endDate');
    print('🌍 Coordinates: ($latitude, $longitude)');
    print('🛫 Origin: ${originAddress ?? 'Not specified'}');

    final now = DateTime.now();

    final trip = Trip(
      destination: destination,
      daysCount: daysCount,
      focus: focus,
      travelersType: travelersType,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
      latitude: latitude,
      longitude: longitude,
      originAddress: originAddress,
      originLat: originLat,
      originLon: originLon,
      createdAt: now,
    );

    final inserted = await Trip.db.insertRow(session, trip);

    print('✅ Trip created successfully!');
    print('🆔 Trip ID: ${inserted.id}');
    print('⏰ Created at: ${inserted.createdAt}');
    print('========================================\n');

    return inserted;
  }

  Future<Trip> updateTrip(
    Session session,
    Trip trip,
  ) async {
    print('\n========================================');
    print('🚀 UPDATE TRIP STARTED');
    print('========================================');
    print('🆔 Trip ID: ${trip.id}');
    print('📍 Destination: ${trip.destination}');
    
    final updated = await Trip.db.updateRow(session, trip);
    
    print('✅ Trip updated successfully!');
    print('========================================\n');
    
    return updated;
  }

  Future<List<Trip>> listTrips(Session session) async {
    print('📋 Listing all trips...');
    final trips = await Trip.db.find(session);
    print('✅ Found ${trips.length} trips');
    return trips;
  }

  Future<Trip> generateItinerary(
    Session session, {
    required int tripId,
    required String userDescription,
  }) async {
    print('\n========================================');
    print('🤖 GENERATE ITINERARY STARTED');
    print('========================================');
    print('🆔 Trip ID: $tripId');
    print('📝 User description: $userDescription');

    // 1. Load the trip
    print('\n[Step 1/6] Loading trip from database...');
    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      print('❌ ERROR: Trip not found!');
      throw ArgumentError('Trip not found');
    }
    print('✅ Trip loaded: ${trip.destination}, ${trip.daysCount} days');
    print('📆 Trip dates: ${trip.startDate} to ${trip.endDate}');

    // 2. Build prompt
    print('\n[Step 2/6] Building Gemini prompt...');
    final prompt = _buildItineraryPrompt(trip, userDescription);
    print('✅ Prompt built (${prompt.length} characters)');

    // 3. Call Gemini with retry logic
    print('\n[Step 3/6] Calling Gemini API...');
    print('⏳ This may take 10-30 seconds...');
    final client = createGeminiClient(session);

    GenerateContentResponse? response;
    int retries = 0;
    const maxRetries = 3;
    final modelsToTry = [
      'gemini-2.0-flash-exp',
      'gemini-2.5-flash',
      'gemini-2.0-flash-lite',
    ];

    while (response == null && retries < maxRetries) {
      try {
        final modelToUse = modelsToTry[retries % modelsToTry.length];
        print('Attempt ${retries + 1}/$maxRetries using model: $modelToUse');

        response = await client.models.generateContent(
          model: modelToUse,
          request: GenerateContentRequest(
            contents: [
              Content.text(prompt),
            ],
          ),
        );

        print('✅ Success with model: $modelToUse');
      } catch (e) {
        retries++;
        print('⚠️  Attempt $retries failed: $e');

        if (retries < maxRetries) {
          // Exponential backoff: 2s, 4s, 8s
          final delaySeconds = 2 * (1 << (retries - 1));
          print('⏳ Waiting ${delaySeconds}s before retry...');
          await Future.delayed(Duration(seconds: delaySeconds));
        } else {
          print('❌ All retry attempts exhausted');
          throw StateError(
            'Failed to generate itinerary after $maxRetries attempts. Please try again later.',
          );
        }
      }
    }

    if (response == null) {
      throw StateError('Failed to get response from Gemini');
    }

    final rawText = response.text;
    if (rawText == null) {
      print('❌ ERROR: Gemini returned no text!');
      throw StateError('Gemini returned no text');
    }

    print('✅ Gemini response received (${rawText.length} characters)');
    print(
      '📄 Raw response preview: ${rawText.substring(0, rawText.length > 200 ? 200 : rawText.length)}...',
    );

    // Clean the response - remove markdown code blocks
    String jsonText = rawText.trim();

    // Remove ```json or ``` from the beginning
    if (jsonText.startsWith('```json')) {
      jsonText = jsonText.substring(7);
    } else if (jsonText.startsWith('```')) {
      jsonText = jsonText.substring(3);
    }

    // Remove ``` from the end
    if (jsonText.endsWith('```')) {
      jsonText = jsonText.substring(0, jsonText.length - 3);
    }

    jsonText = jsonText.trim();

    print(
      '📄 Cleaned JSON preview: ${jsonText.substring(0, jsonText.length > 200 ? 200 : jsonText.length)}...',
    );

    final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
    final days = decoded['days'] as List<dynamic>? ?? [];
    print('✅ JSON parsed: ${days.length} days found');

    // 4. Clear existing plan for this trip (if regenerating)
    print('\n[Step 4/6] Checking for existing itinerary...');
    final existingDays = await TripDay.db.find(
      session,
      where: (t) => t.tripId.equals(tripId),
    );

    if (existingDays.isNotEmpty) {
      print('🗑️  Found existing itinerary with ${existingDays.length} days');
      print('🗑️  Deleting old activities...');
      await Activity.db.deleteWhere(
        session,
        where: (a) => a.tripDayId.inSet(
          existingDays.map((d) => d.id!).toSet(),
        ),
      );
      print('🗑️  Deleting old days...');
      await TripDay.db.deleteWhere(
        session,
        where: (t) => t.tripId.equals(tripId),
      );
      print('✅ Old itinerary cleared');
    } else {
      print('✅ No existing itinerary found (this is a new trip)');
    }

    // 5. Insert new TripDay + Activity rows
    print('\n[Step 5/6] Creating new itinerary...');
    var dayIndex = 1;
    var totalActivities = 0;

    for (final day in days) {
      final dayMap = day as Map<String, dynamic>;

      // Calculate the actual date for this day based on trip start date
      final actualDate = trip.startDate.add(Duration(days: dayIndex - 1));

      final tripDay = TripDay(
        tripId: tripId,
        dayIndex: dayIndex,
        date: actualDate,
        summary: dayMap['summary'] as String?,
      );

      final insertedDay = await TripDay.db.insertRow(session, tripDay);
      print('  📆 Day $dayIndex created (ID: ${insertedDay.id})');
      print('     Date: ${actualDate.toIso8601String().split('T')[0]}');
      print('     Summary: ${insertedDay.summary ?? 'No summary'}');

      final activities = dayMap['activities'] as List<dynamic>? ?? [];
      print('     Activities: ${activities.length}');

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
        final normalizedCategory =
            [
              'hotel',
              'sightseeing',
              'food',
              'airport',
              'transport',
              'activity',
            ].contains(category)
            ? category
            : 'activity';

        // Parse times and combine with actual date
        DateTime? startTime;
        DateTime? endTime;

        final rawStartTime = a['startTime'];
        final rawEndTime = a['endTime'];

        if (rawStartTime != null && rawStartTime is String) {
          final parsedStart = DateTime.tryParse(rawStartTime);
          if (parsedStart != null) {
            // Combine the date from actualDate with time from parsed timestamp
            startTime = DateTime(
              actualDate.year,
              actualDate.month,
              actualDate.day,
              parsedStart.hour,
              parsedStart.minute,
              parsedStart.second,
            );
          }
        }

        if (rawEndTime != null && rawEndTime is String) {
          final parsedEnd = DateTime.tryParse(rawEndTime);
          if (parsedEnd != null) {
            endTime = DateTime(
              actualDate.year,
              actualDate.month,
              actualDate.day,
              parsedEnd.hour,
              parsedEnd.minute,
              parsedEnd.second,
            );
          }
        }

        final activity = Activity(
          tripDayId: insertedDay.id!,
          title: a['title'] as String,
          description: (a['description'] as String?) ?? '',
          category: normalizedCategory,
          startTime: startTime,
          endTime: endTime,
          locationName: a['locationName'] as String?,
          lat: safeLat,
          lon: safeLon,
          estimatedCost: (a['estimatedCost'] as num?)?.toDouble(),
        );

        await Activity.db.insertRow(session, activity);
        totalActivities++;

        final timeStr = activity.startTime != null
            ? '${activity.startTime!.hour.toString().padLeft(2, '0')}:${activity.startTime!.minute.toString().padLeft(2, '0')}'
            : 'flexible';
        print('       • [$timeStr] ${activity.title} (${activity.category})');
      }

      dayIndex++;
      print('');
    }

    print('✅ Itinerary creation complete!');
    print('📊 Summary: ${days.length} days, $totalActivities activities');

    // 6. Return trip
    print('\n[Step 6/6] Returning trip object...');
    print('========================================');
    print('✅ GENERATE ITINERARY COMPLETED');
    print('========================================\n');

    return trip;
  }

  String _buildItineraryPrompt(Trip trip, String userDescription) {
    // Format dates for the prompt
    final startDateStr = trip.startDate.toIso8601String().split('T')[0];
    final endDateStr = trip.endDate.toIso8601String().split('T')[0];

    return '''
You are an expert travel planner with deep knowledge of ${trip.destination}.

Create a REALISTIC, DETAILED ${trip.daysCount}-day itinerary for:
Destination: ${trip.destination}
Focus: ${trip.focus}
Travellers: ${trip.travelersType}
Budget: ${trip.budget ?? 'not specified'}
Start Date: $startDateStr
End Date: $endDateStr

User extra description:
"$userDescription"

CRITICAL REQUIREMENTS - YOU MUST FOLLOW THESE EXACTLY:

1. REAL PLACES ONLY - NO GENERIC NAMES:
   ❌ WRONG: "Local Restaurant", "Um Laylah Budget Retreat", "A nearby cafe", "Local Eatery"
   ✅ CORRECT: "Al Fanar Restaurant & Cafe", "JA Hatta Fort Hotel", "Arabian Tea House", "Ravi Restaurant"
   
   - Hotel: Use a REAL hotel name that exists in ${trip.destination}. Research the actual name.
   - Restaurants: Use SPECIFIC restaurant names (e.g., "Zaroob", "Bu Qtair", "Operation Falafel")
   - Activities: Use EXACT location names (e.g., "Dubai Mall", "Burj Khalifa", "Hatta Wadi Hub")
   - Shops/Malls: Use REAL names (e.g., "Gold Souk", "Carrefour", "Marina Mall")

2. SPECIFIC TIMES - NO "FLEXIBLE":
   ❌ WRONG: Leaving times as null or flexible
   ✅ CORRECT: Every activity MUST have startTime and endTime
   
   Examples of proper times:
   - "startTime": "09:00:00", "endTime": "10:30:00"
   - "startTime": "13:00:00", "endTime": "14:30:00"
   - "startTime": "19:00:00", "endTime": "21:00:00"

3. DETAILED DESCRIPTIONS WITH TRAVEL TIME:
   ❌ WRONG: "Short description", "Enjoy your meal", "Explore the area"
   ✅ CORRECT: "15-minute taxi ride from JA Hatta Fort Hotel. Traditional Emirati breakfast buffet with Arabic coffee."
   
   Every description MUST include:
   - Travel time and method from previous location
   - What makes this place special
   - What to expect

4. SPECIFIC ACTIVITIES - NO VAGUE DESCRIPTIONS:
   ❌ WRONG: "Gentle Exploration Walk", "Free Time", "Local Exploration"
   ✅ CORRECT: "Hike the Hatta Mountain Trail to Wadi Shawka", "Visit Dubai Fountain Show at Dubai Mall"

5. MAKE IT REALISTIC:
   - Use actual opening hours of places
   - Account for realistic travel times
   - Match activities to the destination's actual attractions
   - Consider the budget level (cheap/moderate/luxury)
   - The last day must include airport transfer with proper timing

STRUCTURE YOUR RESPONSE:
- Day 1: Arrival, hotel check-in, settle in, evening exploration
- Middle days: Full day activities matching the focus (${trip.focus})
- Last day: Morning activity, lunch, checkout, airport transfer

For every activity, include accurate coordinates:
- Research the real latitude/longitude of the place
- If you genuinely don't know, set lat and lon to null

Budget guidance for ${trip.budget ?? 'moderate budget'}:
- Cheap: Budget hotels, street food, free/low-cost activities
- Moderate: 3-star hotels, mix of local and tourist restaurants
- Luxury: 4-5 star hotels, fine dining, premium experiences

Allowed categories ONLY:
- "hotel" (check-in/check-out only)
- "sightseeing" (museums, landmarks, viewpoints)
- "food" (breakfast, lunch, dinner, cafes)
- "airport" (arrival/departure only)
- "transport" (taxi, metro, transfers between locations)
- "activity" (hiking, shopping, entertainment, sports)

TIME FORMAT RULES:
- Use 24-hour format: "14:00:00" NOT "2:00 PM"
- Only include TIME, never include dates in startTime/endTime
- Example: "startTime": "09:30:00" ✅
- Example: "startTime": "2025-06-01T09:30:00" ❌

RESPOND ONLY WITH RAW JSON (no markdown, no ```json, no backticks):

{
  "days": [
    {
      "summary": "Arrival day - Check into JA Hatta Fort Hotel and explore the nearby Hatta Heritage Village",
      "activities": [
        {
          "title": "Arrive at Dubai International Airport (DXB)",
          "description": "International arrival terminal. Collect luggage and proceed to ground transportation.",
          "category": "airport",
          "startTime": "10:00:00",
          "endTime": "11:00:00",
          "locationName": "Dubai International Airport - Terminal 3",
          "lat": 25.2532,
          "lon": 55.3657,
          "estimatedCost": 0
        },
        {
          "title": "Transfer to JA Hatta Fort Hotel",
          "description": "90-minute taxi ride from DXB to Hatta. Scenic desert and mountain drive.",
          "category": "transport",
          "startTime": "11:00:00",
          "endTime": "12:30:00",
          "locationName": "JA Hatta Fort Hotel, Hatta",
          "lat": 24.8037,
          "lon": 56.1265,
          "estimatedCost": 250
        }
      ]
    }
  ]
}

REMEMBER: Use ONLY real place names, NEVER generic placeholders. Every activity needs specific times.
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
    print('\n========================================');
    print('📖 GET TRIP WITH PLAN');
    print('========================================');
    print('🆔 Trip ID: $tripId');

    print('\n[Step 1/3] Loading trip...');
    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      print('❌ ERROR: Trip not found!');
      throw ArgumentError('Trip not found');
    }
    print('✅ Trip: ${trip.destination} (${trip.daysCount} days)');

    print('\n[Step 2/3] Loading days...');
    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
      orderBy: (d) => d.dayIndex,
    );
    print('✅ Found ${days.length} days');
    for (final day in days) {
      print('   Day ${day.dayIndex}: ${day.summary ?? 'No summary'}');
    }

    print('\n[Step 3/3] Loading activities...');
    final dayIds = days.map((d) => d.id!).toSet();
    final activities = await Activity.db.find(
      session,
      where: (a) => a.tripDayId.inSet(dayIds),
    );
    print('✅ Found ${activities.length} activities');

    // Group activities by day
    final activitiesByDay = <int, List<Activity>>{};
    for (final activity in activities) {
      activitiesByDay.putIfAbsent(activity.tripDayId, () => []).add(activity);
    }

    for (final day in days) {
      final dayActivities = activitiesByDay[day.id!] ?? [];
      print('   Day ${day.dayIndex}: ${dayActivities.length} activities');
      for (final act in dayActivities) {
        final timeStr = act.startTime != null
            ? '${act.startTime!.hour.toString().padLeft(2, '0')}:${act.startTime!.minute.toString().padLeft(2, '0')}'
            : 'flexible';
        print('      • [$timeStr] ${act.title} (${act.category})');
      }
    }

    final result = TripWithPlan(
      trip: trip,
      days: days,
      activities: activities,
    );

    print('\n✅ TripWithPlan created successfully!');
    print(
      '📊 Final count: ${result.days.length} days, ${result.activities.length} activities',
    );
    print('========================================\n');

    return result;
  }

  Future<List<Activity>> getActivitiesForTrip(
    Session session, {
    required int tripId,
  }) async {
    print('📋 Getting activities for trip $tripId');
    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
    );
    if (days.isEmpty) {
      print('⚠️  No days found for this trip');
      return [];
    }

    final dayIds = days.map((d) => d.id!).toSet();
    final activities = await Activity.db.find(
      session,
      where: (a) => a.tripDayId.inSet(dayIds),
    );
    print('✅ Found ${activities.length} activities');
    return activities;
  }

  Future<List<Reminder>> getUpcomingActivities(
    Session session, {
    required int tripId,
  }) async {
    print('⏰ Getting upcoming activities for trip $tripId');
    final now = DateTime.now().toUtc();
    final next24 = now.add(const Duration(hours: 24));

    final days = await TripDay.db.find(
      session,
      where: (d) => d.tripId.equals(tripId),
    );
    if (days.isEmpty) {
      print('⚠️  No days found');
      return [];
    }

    final dayIds = days.map((d) => d.id!).toSet();
    final activities = await Activity.db.find(
      session,
      where: (a) =>
          a.tripDayId.inSet(dayIds) &
          a.startTime.notEquals(null) &
          (a.startTime >= now) &
          (a.startTime <= next24),
      orderBy: (a) => a.startTime,
    );

    print('✅ Found ${activities.length} upcoming activities');

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
    print('📰 Generating day summary for trip $tripId, day $dayIndex');

    final trip = await Trip.db.findById(session, tripId);
    if (trip == null) {
      throw ArgumentError('Trip not found');
    }

    final day = await TripDay.db.findFirstRow(
      session,
      where: (d) => d.tripId.equals(tripId) & d.dayIndex.equals(dayIndex),
    );
    if (day == null) {
      throw ArgumentError('Day $dayIndex not found for trip');
    }

    final activities = await Activity.db.find(
      session,
      where: (a) => a.tripDayId.equals(day.id!),
      orderBy: (a) => a.startTime,
    );

    print('⏳ Calling Gemini for day summary...');
    final client = createGeminiClient(session);
    final prompt = _buildDaySummaryPrompt(trip, day, activities);

    final response = await client.models.generateContent(
      model: 'gemini-2.5-flash',
      request: GenerateContentRequest(
        contents: [Content.text(prompt)],
      ),
    );

    final text = response.text ?? 'No summary available today.';
    print('✅ Day summary generated (${text.length} chars)');

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
      'Create a concise, motivational morning briefing for a traveler.',
    );
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
        '- [$timePart] ${a.title} (${a.category}) at ${a.locationName ?? 'N/A'}',
      );
    }

    buffer.writeln('');
    buffer.writeln(
      'Write in 2–3 short, friendly sentences. Mention the main highlights,',
    );
    buffer.writeln(
      'and add one small tip (e.g., bring water, arrive early, wear comfortable shoes).',
    );
    buffer.writeln('Do NOT list the activities again as bullets.');
    buffer.writeln('Just respond with the briefing text, nothing else.');

    return buffer.toString();
  }
}
