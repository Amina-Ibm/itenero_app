import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

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
}
