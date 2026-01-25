import 'package:itenero_app_client/itenero_app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this
import 'package:itenero_app_flutter/core/core.dart';
import 'package:itenero_app_flutter/routes/routes.dart';
import 'package:itenero_app_flutter/packages/client_provider.dart'; // Add this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
