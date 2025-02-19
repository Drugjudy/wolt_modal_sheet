import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A widget that wraps the Sticky Action Bar in the [SliverWoltModalSheetPage].
///
/// It handles the conditional rendering of the Sticky Action Bar and the
/// gradient overlay above it, based on the configurations provided in the [SliverWoltModalSheetPage].
class WoltStickyActionBarWrapper extends StatelessWidget {
  /// Constructs a `WoltStickyActionBarWrapper`.
  ///
  /// The [page] argument must not be null.
  const WoltStickyActionBarWrapper({required this.page, Key? key})
      : super(key: key);

  /// The [SliverWoltModalSheetPage] which provides configuration for the Sticky Action Bar
  /// and potentially its gradient overlay.
  final SliverWoltModalSheetPage page;

  @visibleForTesting
  static const gradientWidgetKey =
      ValueKey("WoltStickyActionBarWrapperGradient");

  @override
  Widget build(BuildContext context) {
    // Fetch the sticky action bar from the provided page
    final stickyActionBar = page.stickyActionBar;

    // If there's no action bar provided, render nothing.
    if (stickyActionBar == null) {
      return const SizedBox.shrink();
    }
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final backgroundColor = page.sabGradientColor ??
        themeData?.sabGradientColor ??
        defaultThemeData.sabGradientColor;
    final hasSabGradient = page.hasSabGradient ??
        themeData?.hasSabGradient ??
        defaultThemeData.hasSabGradient;
    final surfaceTintColor =
        themeData?.surfaceTintColor ?? defaultThemeData.surfaceTintColor;
    return Column(
      children: [
        // If a gradient is required, add a Container with a linear gradient decoration.
        if (hasSabGradient)
          Container(
            key: gradientWidgetKey,
            height: themeData?.sabGradientHeight ??
                defaultThemeData.sabGradientHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0),
                ],
              ),
            ),
          ),
        // Render the sticky action bar with its background color.
        if (hasSabGradient)
          Material(
            type: MaterialType.canvas,
            color: backgroundColor,
            surfaceTintColor: surfaceTintColor,
            child: stickyActionBar,
          )
        else
          stickyActionBar,
      ],
    );
  }
}
