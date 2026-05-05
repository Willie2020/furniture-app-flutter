import 'package:flutter/material.dart';

/// A reusable expandable SliverAppBar with a gradient background that
/// compresses elegantly when scrolling down.
///
/// Material Design 3 "large top app bar" / "medium top app bar" variant
/// with custom branding.
class ExpandableSliverHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget>? actions;
  final double expandedHeight;
  final bool pinned;

  const ExpandableSliverHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actions,
    this.expandedHeight = 180,
    this.pinned = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: pinned,
      stretch: true,
      expandedHeight: expandedHeight,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      actions: actions,
      // Slight elevation when collapsed so it separates from content
      scrolledUnderElevation: 2,
      elevation: 0,
      // The gradient background
      flexibleSpace: FlexibleSpaceBar(
        // FlexibleSpaceBar.title handles the expand → collapse transition
        // automatically: it's visible in the expanded area and slides into
        // the toolbar when collapsed.
        title: Text(
          title,
          style: tt.titleLarge?.copyWith(color: cs.onPrimary),
        ),
        // Default is 72px left to make room for a back button. Since these
        // pages have no leading widget, use the standard 16px inset.
        titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
        centerTitle: false,
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.primary,
                cs.tertiary,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.onPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 28, color: cs.onPrimary),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // The expanded title is rendered by FlexibleSpaceBar.title
                  // so it automatically disappears when collapsed.
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.75),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
    );
  }
}
