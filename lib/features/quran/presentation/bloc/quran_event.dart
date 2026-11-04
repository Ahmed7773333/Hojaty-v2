import 'package:equatable/equatable.dart';
import '../../domain/entities/qirat_type.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuranDataEvent extends QuranEvent {
  const LoadQuranDataEvent();
}

class ToggleOverlayEvent extends QuranEvent {
  const ToggleOverlayEvent();
}

class JumpToPageEvent extends QuranEvent {
  final int pageNumber;

  const JumpToPageEvent(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class PageChangedEvent extends QuranEvent {
  final int pageNumber;

  const PageChangedEvent(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class SearchQuranEvent extends QuranEvent {
  final String query;

  const SearchQuranEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectQiratEvent extends QuranEvent {
  final QiratType qirat;

  const SelectQiratEvent(this.qirat);

  @override
  List<Object?> get props => [qirat];
}

class CheckQuranAssetStatusEvent extends QuranEvent {
  const CheckQuranAssetStatusEvent();
}

class StartDownloadQuranAssetEvent extends QuranEvent {
  final QiratType? qirat;

  const StartDownloadQuranAssetEvent({this.qirat});

  @override
  List<Object?> get props => [qirat];
}

class CancelDownloadQuranAssetEvent extends QuranEvent {
  const CancelDownloadQuranAssetEvent();
}

class AssetDownloadProgressUpdatedEvent extends QuranEvent {
  final String? packName;
  final int bytesDownloaded;
  final int totalBytes;
  final double progress;
  final String status;
  final String? assetsPath;
  final int? errorCode;

  const AssetDownloadProgressUpdatedEvent({
    this.packName,
    required this.bytesDownloaded,
    required this.totalBytes,
    required this.progress,
    required this.status,
    this.assetsPath,
    this.errorCode,
  });

  @override
  List<Object?> get props => [
        packName,
        bytesDownloaded,
        totalBytes,
        progress,
        status,
        assetsPath,
        errorCode,
      ];
}
