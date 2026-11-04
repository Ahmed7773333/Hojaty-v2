import 'package:equatable/equatable.dart';

enum BookDownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  failed,
}

class BookDownloadProgress extends Equatable {
  final String bookId;
  final BookDownloadStatus status;
  final double progress;
  final int bytesDownloaded;
  final int totalBytes;
  final String? localFilePath;
  final String? errorMessage;

  const BookDownloadProgress({
    required this.bookId,
    this.status = BookDownloadStatus.notDownloaded,
    this.progress = 0.0,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.localFilePath,
    this.errorMessage,
  });

  BookDownloadProgress copyWith({
    BookDownloadStatus? status,
    double? progress,
    int? bytesDownloaded,
    int? totalBytes,
    String? localFilePath,
    String? errorMessage,
  }) {
    return BookDownloadProgress(
      bookId: bookId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      localFilePath: localFilePath ?? this.localFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        status,
        progress,
        bytesDownloaded,
        totalBytes,
        localFilePath,
        errorMessage,
      ];
}

