import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/routes.dart';

import 'core/services/storage_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service before app starts
  final storageService = StorageService();
  await storageService.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Modern Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.getInitialRoute(),
      getPages: AppRoutes.getPages(),
    );
  }
}