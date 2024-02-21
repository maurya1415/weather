import 'package:flutter/material.dart';

class CustomTextStyle {
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final double? height;
  final Color? color;
  final Paint? background;
  final Decoration? decoration;

  final double? decorationThickness;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;
  final String? debugLabel;
  final Locale? locale;
  final List<Shadow>? shadows;

  final TextDecoration? overflow;
  final TextOverflow? overflowReplacement;
  final TextDecoration? softWrap;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? localeStrutFallback;
  final bool? inherit;
  final int? maxLines;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final String? fontFamilyFallbackFallback;
  final bool? allowFontScaling;

  CustomTextStyle({
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.color,
    this.background,
    this.decoration,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.debugLabel,
    this.locale,
    this.shadows,
    this.overflow,
    this.overflowReplacement,
    this.softWrap,
    this.textAlign,
    this.textAlignVertical,
    this.textDirection,
    this.localeStrutFallback,
    this.inherit,
    this.maxLines,
    this.semanticsLabel,
    this.textScaleFactor,
    this.fontFamilyFallbackFallback,
    this.allowFontScaling,
  });

  TextStyle get textStyle {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      color: color,
      background: background,
      decorationThickness: decorationThickness,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      debugLabel: debugLabel,
      locale: locale,
      shadows: shadows,
    );
  }
}
