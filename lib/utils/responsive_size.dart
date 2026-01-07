import 'package:flutter/material.dart';

/// BuildContext extension - Her yerde context.responsive şeklinde kullanılabilir
extension ResponsiveExtension on BuildContext {
  ResponsiveSize get responsive => ResponsiveSize(this);
}

/// Responsive boyutlandırma sınıfı
class ResponsiveSize {
  final BuildContext context;
  late final double _width;
  late final double _height;

  ResponsiveSize(this.context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
  }

  // Ekran boyutları
  double get width => _width;
  double get height => _height;

  // Genişlik bazlı ölçüler (Width Percentage)
  double wp(double percentage) => _width * (percentage / 100);

  // Yükseklik bazlı ölçüler (Height Percentage)
  double hp(double percentage) => _height * (percentage / 100);

  // Responsive font boyutu
  double sp(double size) => wp(size / 10).clamp(size * 0.8, size * 1.4);

  // Responsive padding/margin
  EdgeInsets get paddingAll => EdgeInsets.all(wp(4));
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: wp(4));
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: hp(2));

  // Responsive spacing
  SizedBox get verticalSpaceSmall => SizedBox(height: hp(1));
  SizedBox get verticalSpaceMedium => SizedBox(height: hp(2));
  SizedBox get verticalSpaceLarge => SizedBox(height: hp(3));
  SizedBox get verticalSpaceExtraLarge => SizedBox(height: hp(5));

  SizedBox get horizontalSpaceSmall => SizedBox(width: wp(2));
  SizedBox get horizontalSpaceMedium => SizedBox(width: wp(4));
  SizedBox get horizontalSpaceLarge => SizedBox(width: wp(6));

  // Cihaz tipi kontrolü
  bool get isMobile => _width < 600;
  bool get isTablet => _width >= 600 && _width < 1024;
  bool get isDesktop => _width >= 1024;
}