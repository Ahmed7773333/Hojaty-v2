import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  /// The label text displayed above the field.
  final String? label;

  /// The hint text displayed inside the field when empty.
  final String? hintText;

  /// Whether the field is required (shows a red asterisk next to the label).
  final bool isRequired;

  /// Controller for the text field.
  final TextEditingController? controller;

  /// The keyboard type (e.g., email, number, phone).
  final TextInputType? keyboardType;

  /// The text input action (e.g., next, done, search).
  final TextInputAction? textInputAction;

  /// Whether the text is obscured (for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Maximum number of lines.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Prefix icon inside the field.
  final Widget? prefixIcon;

  /// Suffix icon inside the field (e.g., visibility toggle).
  final Widget? suffixIcon;

  /// Prefix widget (e.g., country code).
  final Widget? prefix;

  /// Suffix widget.
  final Widget? suffix;

  /// Form field validator.
  final String? Function(String?)? validator;

  /// Called when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the field is submitted.
  final ValueChanged<String>? onFieldSubmitted;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the field is saved (via Form).
  final FormFieldSetter<String>? onSaved;

  /// Focus node for controlling focus.
  final FocusNode? focusNode;

  /// Initial value (use instead of controller if not needed).
  final String? initialValue;

  /// Input formatters (e.g., digits only, max length).
  final List<TextInputFormatter>? inputFormatters;

  /// Auto-validation mode.
  final AutovalidateMode? autovalidateMode;

  /// Whether to auto-correct text.
  final bool autocorrect;

  /// Whether to enable suggestions.
  final bool enableSuggestions;

  /// Text alignment inside the field.
  final TextAlign textAlign;

  /// Style for the input text.
  final TextStyle? style;

  /// Style for the label text.
  final TextStyle? labelStyle;

  /// Style for the hint text.
  final TextStyle? hintStyle;

  /// Style for the error text.
  final TextStyle? errorStyle;

  /// Custom content padding inside the field.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the field fills the background color.
  final bool filled;

  /// Background fill color.
  final Color? fillColor;

  /// Custom border radius.
  final double borderRadius;

  /// Custom border color.
  final Color? borderColor;

  /// Custom focused border color.
  final Color? focusedBorderColor;

  /// Custom error border color.
  final Color? errorBorderColor;

  /// Border width.
  final double borderWidth;

  /// Custom enabled border.
  final InputBorder? enabledBorder;

  /// Custom focused border.
  final InputBorder? focusedBorder;

  /// Custom error border.
  final InputBorder? errorBorder;

  /// Custom focused error border.
  final InputBorder? focusedErrorBorder;

  /// Custom disabled border.
  final InputBorder? disabledBorder;

  /// Text capitalization.
  final TextCapitalization textCapitalization;

  /// Whether to expand to fill available space.
  final bool expands;

  /// Counter text.
  final String? counterText;

  /// Helper text below the field.
  final String? helperText;

  /// Cursor color.
  final Color? cursorColor;

  /// Space between the label and the text field.
  final double labelSpacing;

  /// Whether to show the counter.
  final bool showCounter;

  /// Whether this field is specifically for phone numbers.
  final bool isPhoneField;

  /// The country code to display if this is a phone field.
  final String? countryCode;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onSaved,
    this.focusNode,
    this.initialValue,
    this.inputFormatters,
    this.autovalidateMode,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.contentPadding,
    this.filled = true,
    this.fillColor,
    this.borderRadius = 12.0,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth = 1.0,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.textCapitalization = TextCapitalization.none,
    this.expands = false,
    this.counterText,
    this.helperText,
    this.cursorColor,
    this.labelSpacing = 8.0,
    this.showCounter = false,
    this.isPhoneField = false,
    this.countryCode = '+234',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          _buildLabel(theme),
          SizedBox(height: labelSpacing),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: isPhoneField ? TextInputType.phone : keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: expands ? null : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          focusNode: focusNode,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onSaved: onSaved,
          inputFormatters: [
            if (isPhoneField) FilteringTextInputFormatter.digitsOnly,
            ...?inputFormatters,
          ],
          autovalidateMode: autovalidateMode,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          expands: expands,
          cursorColor: cursorColor,
          style:
              style ??
              theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
          decoration: _buildDecoration(theme),
        ),
      ],
    );
  }

  Widget _buildLabel(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style:
              labelStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration(ThemeData theme) {
    final defaultBorderRadius = BorderRadius.circular(borderRadius);

    final defaultEnabledBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(
        color: borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.3),
        width: borderWidth,
      ),
    );

    final defaultFocusedBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(
        color: focusedBorderColor ?? theme.colorScheme.primary,
        width: borderWidth + 0.5,
      ),
    );

    final defaultErrorBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(
        color: errorBorderColor ?? theme.colorScheme.error,
        width: borderWidth,
      ),
    );

    final defaultFocusedErrorBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(
        color: errorBorderColor ?? theme.colorScheme.error,
        width: borderWidth + 0.5,
      ),
    );

    final defaultDisabledBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(
        color: theme.colorScheme.outline.withValues(alpha: 0.15),
        width: borderWidth,
      ),
    );

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
      errorStyle: errorStyle,
      prefixIcon: isPhoneField
          ? Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color:
                          borderColor ??
                          theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      countryCode ?? '+234',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            )
          : prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefix,
      suffix: suffix,
      filled: filled,
      fillColor:
          fillColor ??
          (enabled
              ? theme.colorScheme.surface
              : theme.colorScheme.onSurface.withValues(alpha: 0.04)),
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: enabledBorder ?? defaultEnabledBorder,
      focusedBorder: focusedBorder ?? defaultFocusedBorder,
      errorBorder: errorBorder ?? defaultErrorBorder,
      focusedErrorBorder: focusedErrorBorder ?? defaultFocusedErrorBorder,
      disabledBorder: disabledBorder ?? defaultDisabledBorder,
      counterText: showCounter ? null : (counterText ?? ''),
      helperText: helperText,
    );
  }
}
