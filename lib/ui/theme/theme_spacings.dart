import 'package:gap/gap.dart';

/// Simple spacing components that follow a 4-point grid system.
///
/// Internally all it does it using a [Gap] widget with a fixed extent.
abstract final class Space {
  /// Space (either horizontal or vertical) of size 4.
  static const xxs = Gap(ThemeSpacing.xxs);

  /// Space (either horizontal or vertical) of size 8.
  static const xs = Gap(ThemeSpacing.xs);

  /// Space (either horizontal or vertical) of size 12.
  static const s = Gap(ThemeSpacing.s);

  /// Space (either horizontal or vertical) of size 16.
  static const sm = Gap(ThemeSpacing.sm);

  /// Space (either horizontal or vertical) of size 24.
  static const m = Gap(ThemeSpacing.m);

  /// Space (either horizontal or vertical) of size 32.
  static const ml = Gap(ThemeSpacing.ml);

  /// Space (either horizontal or vertical) of size 32.
  static const Gap lm = ml;

  /// Space (either horizontal or vertical) of size 40.
  static const l = Gap(ThemeSpacing.l);

  /// Space (either horizontal or vertical) of size 48.
  static const xl = Gap(ThemeSpacing.xl);

  /// Space (either horizontal or vertical) of size 56.
  static const xxl = Gap(ThemeSpacing.xxl);

  static Gap custom(double height) => Gap(height);
}

abstract final class SliverSpace {
  /// Sliver space (either horizontal or vertical) of size 4.
  static const xxs = SliverGap(ThemeSpacing.xxs);

  /// Sliver space (either horizontal or vertical) of size 8.
  static const xs = SliverGap(ThemeSpacing.xs);

  /// Sliver space (either horizontal or vertical) of size 12.
  static const s = SliverGap(ThemeSpacing.s);

  /// Sliver space (either horizontal or vertical) of size 16.
  static const sm = SliverGap(ThemeSpacing.sm);

  /// Sliver space (either horizontal or vertical) of size 24.
  static const m = SliverGap(ThemeSpacing.m);

  /// Sliver space (either horizontal or vertical) of size 32.
  static const ml = SliverGap(ThemeSpacing.ml);

  /// Sliver space (either horizontal or vertical) of size 40.
  static const l = SliverGap(ThemeSpacing.l);

  /// Sliver space (either horizontal or vertical) of size 48.
  static const xl = SliverGap(ThemeSpacing.xl);

  /// Sliver space (either horizontal or vertical) of size 56.
  static const xxl = SliverGap(ThemeSpacing.xxl);

  static SliverGap custom(double height) => SliverGap(height);
}

/// Simple size constants that follow a 4-point grid system.
abstract final class ThemeSize {
  /// 0px.
  static const zero = 0.0;

  /// 4px.
  static const xxs = 4.0;

  /// 8px.
  static const xs = 8.0;

  /// 12px.
  static const s = 12.0;

  /// 16px.
  static const sm = 16.0;

  /// 24px.
  static const m = 24.0;

  /// 32px.
  static const ml = 32.0;

  /// 40px.
  static const l = 40.0;

  /// 48px.
  static const xl = 48.0;

  /// 56px.
  static const xxl = 56.0;
}

typedef ThemeSpacing = ThemeSize;
