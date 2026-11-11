import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/utils/app_colors.dart';
import '../utils/mushaf_shader_program_loader.dart';
import 'mushaf_shader_painter.dart';
import 'quran_page_placeholder_widget.dart';

/// Renders a scanned Mushaf page using the three-layer night-mode fragment shader.
class MushafNightModePageWidget extends StatefulWidget {
  final ImageProvider<Object> imageProvider;
  final int pageNumber;
  final Color textColor;
  final Color accentColor;
  final Color backgroundColor;

  const MushafNightModePageWidget({
    super.key,
    required this.imageProvider,
    required this.pageNumber,
    this.textColor = AppColors.mushafNightText,
    this.accentColor = AppColors.mushafNightAccent,
    this.backgroundColor = AppColors.mushafNightBackground,
  });

  @override
  State<MushafNightModePageWidget> createState() =>
      _MushafNightModePageWidgetState();
}

class _MushafNightModePageWidgetState extends State<MushafNightModePageWidget> {
  ui.FragmentShader? _shader;
  bool _shaderFailed = false;
  ImageStream? _imageStream;
  ImageStreamListener? _streamListener;
  ImageInfo? _imageInfo;
  bool _hasImageError = false;
  bool _isSyncResolve = false;

  @override
  void initState() {
    super.initState();
    final cachedProgram = MushafShaderProgramLoader.cachedProgram;
    if (cachedProgram != null) {
      _shader = cachedProgram.fragmentShader();
    } else {
      _loadShader();
    }
  }

  Future<void> _loadShader() async {
    try {
      final program = await MushafShaderProgramLoader.load();
      if (!mounted) return;
      setState(() {
        _shader = program.fragmentShader();
        _shaderFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _shaderFailed = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(MushafNightModePageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    final newStream = widget.imageProvider.resolve(
      createLocalImageConfiguration(context),
    );
    if (_imageStream?.key == newStream.key) {
      return;
    }

    _stopListening();
    _replaceImage(null);
    _hasImageError = false;
    _imageStream = newStream;

    final listener = ImageStreamListener(
      _handleImageFrame,
      onError: _handleImageError,
    );
    _streamListener = listener;

    _isSyncResolve = true;
    newStream.addListener(listener);
    _isSyncResolve = false;
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    if (_isSyncResolve) {
      _replaceImage(imageInfo);
      _hasImageError = false;
      return;
    }
    if (!mounted) {
      imageInfo.dispose();
      return;
    }
    setState(() {
      _replaceImage(imageInfo);
      _hasImageError = false;
    });
  }

  void _handleImageError(Object error, StackTrace? stackTrace) {
    if (_isSyncResolve) {
      _hasImageError = true;
      return;
    }
    if (!mounted) return;
    setState(() {
      _hasImageError = true;
    });
  }

  void _replaceImage(ImageInfo? nextInfo) {
    final previous = _imageInfo;
    _imageInfo = nextInfo;
    if (previous != null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => previous.dispose(),
      );
    }
  }

  void _stopListening() {
    if (_imageStream != null && _streamListener != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _streamListener = null;
  }

  @override
  void dispose() {
    _stopListening();
    _replaceImage(null);
    _shader?.dispose();
    _shader = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasImageError) {
      return QuranPagePlaceholderWidget(pageNumber: widget.pageNumber);
    }

    if (_shaderFailed) {
      return Image(
        image: widget.imageProvider,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return QuranPagePlaceholderWidget(pageNumber: widget.pageNumber);
        },
      );
    }

    final shader = _shader;
    final imageInfo = _imageInfo;
    if (shader == null || imageInfo == null) {
      return ColoredBox(color: widget.backgroundColor);
    }

    return SizedBox.expand(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: MushafShaderPainter(
            shader: shader,
            image: imageInfo.image,
            textColor: widget.textColor,
            accentColor: widget.accentColor,
            bgColor: widget.backgroundColor,
          ),
        ),
      ),
    );
  }
}

