import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String link;
  final String imageLink;

  const BannerModel({
    required this.id,
    required this.link,
    required this.imageLink,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] ?? '').toString(),
      link: (json['link'] ?? '') as String,
      imageLink: (json['image_link'] ?? json['imageLink'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'image_link': imageLink,
    };
  }

  BannerModel copyWith({
    String? id,
    String? link,
    String? imageLink,
  }) {
    return BannerModel(
      id: id ?? this.id,
      link: link ?? this.link,
      imageLink: imageLink ?? this.imageLink,
    );
  }

  @override
  List<Object?> get props => [id, link, imageLink];
}
