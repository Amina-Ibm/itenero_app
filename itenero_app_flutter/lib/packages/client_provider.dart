import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itenero_app_client/itenero_app_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerConfig {
  static const String productionUrl =
      'https://itenero-server-639636909074.us-central1.run.app/';
  static const String localUrl = 'http://10.0.2.2:8080/';

  static String get serverUrl {
    // For hackathon/production
    return productionUrl;

    // For local development
    // return localUrl;
  }
}

final clientProvider = Provider<Client>((ref) {
  return Client(
    ServerConfig.serverUrl,
    connectionTimeout: const Duration(minutes: 3),
    streamingConnectionTimeout: const Duration(minutes: 3),
  );
});

// Extension to add custom timeout methods
extension ClientTimeoutExtension on Client {
  Future<T> withTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(minutes: 2),
  }) async {
    return operation().timeout(
      timeout,
      onTimeout: () {
        throw TimeoutException(
          'Operation timed out after ${timeout.inSeconds} seconds. Please try again.',
        );
      },
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
