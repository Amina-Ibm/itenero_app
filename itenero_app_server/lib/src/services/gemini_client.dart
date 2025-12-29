import 'package:googleai_dart/googleai_dart.dart';
import 'package:serverpod/serverpod.dart';

GoogleAIClient createGeminiClient(Session session) {
  final apiKey = session.server.passwords['geminiApiKey'];
  if (apiKey == null || apiKey.isEmpty) {
    throw StateError('geminiApiKey is not set in config/passwords.yaml');
  }

  return GoogleAIClient(
    config: GoogleAIConfig.googleAI(
      apiVersion: ApiVersion.v1beta,
      authProvider: ApiKeyProvider(apiKey),
    ),
  );
}
