import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final String? title;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.title,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _resetZoom() {
    if (_isZoomed) {
      _animation =
          Matrix4Tween(
            begin: _transformationController.value,
            end: Matrix4.identity(),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

      _animationController.forward(from: 0).then((_) {
        _transformationController.value = Matrix4.identity();
        setState(() => _isZoomed = false);
      });
    }
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (_animation != null) {
      _animationController.stop();
      _animation = null;
    }
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    _transformationController.value = Matrix4.identity()
      ..scale(details.scale)
      ..translate(details.focalPoint.dx, details.focalPoint.dy);

    setState(() {
      _isZoomed = details.scale > 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Image Viewer
          Center(
            child: GestureDetector(
              onTap: () {
                if (!_isZoomed) {
                  Navigator.of(context).pop();
                } else {
                  _resetZoom();
                }
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  if (_animation != null) {
                    _transformationController.value = _animation!.value;
                  }
                  return InteractiveViewer(
                    transformationController: _transformationController,
                    onInteractionStart: _onInteractionStart,
                    onInteractionUpdate: _onInteractionUpdate,
                    maxScale: 4.0,
                    minScale: 1.0,
                    child: Hero(
                      tag: widget.heroTag,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.white54,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
