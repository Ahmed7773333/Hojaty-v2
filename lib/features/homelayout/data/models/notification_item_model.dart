import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationIconType {
  prayer,
  occasion,
  athkar,
}

class NotificationItemModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationIconType iconType;
  final Color stripeColor;
  final bool isRead;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.iconType,
    required this.stripeColor,
    this.isRead = false,
  });

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? body,
    String? timeAgo,
    NotificationIconType? iconType,
    Color? stripeColor,
    bool? isRead,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timeAgo: timeAgo ?? this.timeAgo,
      iconType: iconType ?? this.iconType,
      stripeColor: stripeColor ?? this.stripeColor,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, timeAgo, iconType, isRead];
}
