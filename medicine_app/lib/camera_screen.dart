import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isEmpty) {
      _controller = CameraController(
        const CameraDescription(
          name: 'No Camera',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0,
        ),
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = Future.error('No camera available');
    } else {
      _controller = CameraController(widget.cameras.first, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || widget.cameras.isEmpty) {
              return const Center(
                child: Text('No camera is available on this device.'),
              );
            }
            return CameraPreview(_controller);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
