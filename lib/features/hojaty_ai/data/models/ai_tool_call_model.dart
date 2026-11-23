import 'package:equatable/equatable.dart';

class AiToolCallModel extends Equatable {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const AiToolCallModel({
    required this.id,
    required this.name,
    required this.arguments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arguments': arguments,
    };
  }

  factory AiToolCallModel.fromJson(Map<String, dynamic> json) {
    return AiToolCallModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      arguments: (json['arguments'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          const {},
    );
  }

  @override
  List<Object?> get props => [id, name, arguments];
}

class AiToolActionResultModel extends Equatable {
  final String toolName;
  final Map<String, dynamic> arguments;
  final Map<String, dynamic> result;
  final String? displayText;
  final bool isSuccess;
  final String? errorMessage;

  const AiToolActionResultModel({
    required this.toolName,
    required this.arguments,
    this.result = const {},
    this.displayText,
    this.isSuccess = true,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'toolName': toolName,
      'arguments': arguments,
      'result': result,
      'displayText': displayText,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
  }

  factory AiToolActionResultModel.fromJson(Map<String, dynamic> json) {
    return AiToolActionResultModel(
      toolName: json['toolName'] as String? ?? '',
      arguments: (json['arguments'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          const {},
      result: (json['result'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          const {},
      displayText: json['displayText'] as String?,
      isSuccess: json['isSuccess'] as bool? ?? true,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        toolName,
        arguments,
        result,
        displayText,
        isSuccess,
        errorMessage,
      ];
}

