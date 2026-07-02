import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isInitializing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) {
      return;
    }

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      final cameras = await availableCameras();
      if (!mounted) {
        return;
      }

      if (cameras.isEmpty) {
        throw Exception('No camera is available on this device.');
      }

      final preferredCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(preferredCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = kIsWeb
            ? 'Camera access needs to be started from a browser interaction. Tap the button below and allow camera access.'
            : 'Unable to start the camera. $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? CameraPreview(_controller!)
            : _buildStatusView(),
      ),
    );
  }

  Widget _buildStatusView() {
    if (_isInitializing) {
      return const CircularProgressIndicator();
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _errorMessage ?? 'Tap the button to start the camera preview.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initializeCamera,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Camera'),
          ),
        ],
      ),
    );
  }
}
