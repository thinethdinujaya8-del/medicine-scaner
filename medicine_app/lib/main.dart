import 'package:flutter/material.dart';

import 'camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraScreen(),
    );
  }
}