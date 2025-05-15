import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../core/network/file_downloader.dart';
import '../../constants/color_constant.dart';

class MediaOverlay {
  static OverlayEntry? _currentOverlay;

  // Static method to show the overlay
  static Future<void> show(BuildContext context, {
    required String url,
    required String title,
    required String fileName
  }) async {
    // First, remove any existing overlay
    _hideCurrentOverlay();

    // Create and insert the overlay entry
    _currentOverlay = OverlayEntry(
      builder: (overlayContext) => _MediaOverlayWidget(
        url: url,
        title: title,
        fileName: fileName,
        onClose: _hideCurrentOverlay,
      ),
    );

    // Ensure we're not in a build phase by using microtask
    Future.microtask(() {
      if (context.mounted) {
        Overlay.of(context).insert(_currentOverlay!);
        // Force Flutter to render the changes immediately
        WidgetsBinding.instance.endOfFrame.then((_) {
          if (context.mounted) {
            WidgetsBinding.instance.scheduleFrame();
          }
        });
      }
    });
  }

  // Method to hide the current overlay
  static void _hideCurrentOverlay() {
    if (_currentOverlay != null) {
      _currentOverlay!.remove();
      _currentOverlay = null;
    }
  }
}

// Separate StatefulWidget for the actual overlay content
class _MediaOverlayWidget extends StatefulWidget {
  final String url;
  final String title;
  final String fileName;
  final VoidCallback onClose;

  const _MediaOverlayWidget({
    required this.url,
    required this.title,
    required this.fileName,
    required this.onClose,
  });

  @override
  State<_MediaOverlayWidget> createState() => _MediaOverlayWidgetState();
}

class _MediaOverlayWidgetState extends State<_MediaOverlayWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideo = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  Future<void> _initializeMedia() async {
    // Check if URL is a video or an image
    _isVideo = _isVideoUrl(widget.url);
    if (_isVideo) {
      await _initializeVideo();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController!.initialize();

    if (mounted) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        aspectRatio: _videoController!.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        placeholder: const Center(
          child: CircularProgressIndicator(
            color: ColorConstant.secondary,
          ),
        ),
      );
    }
  }

  bool _isVideoUrl(String url) {
    // Hanya memeriksa ekstensi .mp4
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.mp4');
  }

  Future<Size> getImageSize(BuildContext context, String imageUrl) async {
    final Image image = Image.network(imageUrl);
    final Completer<Size> completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
          Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ),
        );
      }),
    );

    // Set a maximum size based on the device screen size
    final Size screenSize = MediaQuery.of(context).size;
    final Size maxSize = Size(
      screenSize.width * 0.85,
      screenSize.height * 0.7,
    );

    // Wait for the image to load or timeout after 5 seconds
    Size imageSize;
    try {
      imageSize = await completer.future.timeout(const Duration(seconds: 5));

      // Constrain the image size
      final double aspectRatio = imageSize.width / imageSize.height;
      if (imageSize.width > maxSize.width) {
        imageSize = Size(maxSize.width, maxSize.width / aspectRatio);
      }
      if (imageSize.height > maxSize.height) {
        imageSize = Size(maxSize.height * aspectRatio, maxSize.height);
      }
    } catch (_) {
      // If timeout or error occurs, use a default size
      imageSize = Size(maxSize.width, maxSize.width * 3/4);
    }

    return imageSize;
  }

  Widget _buildMediaContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorConstant.secondary,
        ),
      );
    }

    if (_isVideo) {
      if (_chewieController != null) {
        return Chewie(controller: _chewieController!);
      } else {
        return const Center(child: Text('Error loading video', style: TextStyle(color: Colors.white)));
      }
    } else {
      // For images
      return FutureBuilder<Size>(
        future: getImageSize(context, widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }

          final size = snapshot.data!;
          return Image.network(
            widget.url,
            width: size.width,
            height: size.height,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: ColorConstant.primary,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red[300],
                  size: 40,
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tambahkan WillPopScope untuk menangani tombol kembali
    return WillPopScope(
      onWillPop: () async {
        // Tutup overlay saat tombol back ditekan
        widget.onClose();
        // Kembalikan false agar navigasi tidak dilanjutkan ke screen sebelumnya
        return false;
      },
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Full-screen interactive background
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),

            // Main content with SafeArea
            SafeArea(
              child: Column(
                children: [
                  // Header with close and download buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Close button
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        ),

                        // Download button
                        TextButton.icon(
                          onPressed: () async {
                            await downloadFile(
                              url: widget.url,
                              fileName: widget.fileName,
                              doneTitle: "Selesai mendownload ${_isVideo ? 'video' : 'gambar'} ${widget.title}",
                            );
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text("Download",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Media content in expanded section
                  Expanded(
                    child: GestureDetector(
                      onTap: () {}, // Prevent taps on content from closing overlay
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Media content (image or video)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                                ),
                                child: _buildMediaContent(),
                              ),

                              const SizedBox(height: 16),

                              // Title text (optional)
                              if (widget.title.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose video controllers if initialized
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}