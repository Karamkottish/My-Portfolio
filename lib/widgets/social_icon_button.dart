import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

/// Animated social icon with hover/press/rotate + rainbow ring.
/// - Auto-detects SVG vs raster
/// - Scale + lift + subtle spin on hover, press-in on tap
/// - Rainbow ring + glow on hover/focus
/// - Tooltip + accessibility
class SocialIconButton extends StatefulWidget {
  const SocialIconButton({
    super.key,
    required this.assetPath,
    required this.tooltip,
    required this.url,
    this.size = 44,
    this.semanticLabel,
  });

  final String assetPath;
  final String tooltip;
  final String url;
  final double size;
  final String? semanticLabel;

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (kIsWeb) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Visual state
    final hoverOrFocus = _hovered || _focused;
    final scale = _pressed ? 0.96 : (hoverOrFocus ? 1.08 : 1.0);
    final lift = _pressed ? 0.0 : (hoverOrFocus ? -2.0 : 0.0);
    final ringOpacity = hoverOrFocus ? 1.0 : 0.0; // rainbow ring visibility
    final bgOpacity = hoverOrFocus ? 0.12 : 0.06;
    final border = hoverOrFocus
        ? cs.primary.withOpacity(.45)
        : cs.outlineVariant.withOpacity(.35);

    // Icon widget (SVG or raster)
    Widget icon;
    if (widget.assetPath.toLowerCase().endsWith('.svg')) {
      icon = SvgPicture.asset(
        widget.assetPath,
        width: widget.size * .62,
        height: widget.size * .62,
        colorFilter: ColorFilter.mode(
          cs.onSurface.withOpacity(.92),
          BlendMode.srcIn,
        ),
      );
    } else {
      icon = Image.asset(
        widget.assetPath,
        width: widget.size * .62,
        height: widget.size * .62,
        color: cs.onSurface.withOpacity(.92),
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (_, __, ___) => Icon(
          Icons.link,
          size: widget.size * .58,
          color: cs.onSurfaceVariant,
        ),
      );
    }

    // Rotation (subtle spin on hover)
    final endAngle = hoverOrFocus ? 0.09 /* ~5° */ : 0.0;

    return FocusableActionDetector(
      onShowFocusHighlight: (f) => setState(() => _focused = f),
      onShowHoverHighlight: (h) => setState(() => _hovered = h),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: widget.tooltip,
          waitDuration: const Duration(milliseconds: 350),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: _open,
            child: Semantics(
              label: widget.semanticLabel ?? widget.tooltip,
              button: true,
              link: true,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                transform: Matrix4.identity()..translate(0.0, lift),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ===== Rainbow ring (appears on hover/focus) =====
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: ringOpacity,
                      child: Container(
                        width: widget.size + 14,
                        height: widget.size + 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // Sweep gradient for a rainbow ring
                          gradient: SweepGradient(
                            colors: [
                              Color(0xFF00E5FF),
                              Color(0xFF06D6A0),
                              Color(0xFFFFD166),
                              Color(0xFFFF6AC1),
                              Color(0xFF8B5CF6),
                              Color(0xFF00E5FF),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Inner circular button
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.surfaceVariant.withOpacity(bgOpacity),
                        border: Border.all(color: border, width: 1),
                        boxShadow: [
                          if (hoverOrFocus)
                            BoxShadow(
                              color: cs.primary.withOpacity(.25),
                              blurRadius: 18,
                              spreadRadius: 1.0,
                            ),
                        ],
                      ),
                      padding: EdgeInsets.all(widget.size * .19),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: endAngle),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        builder: (context, angle, child) {
                          return AnimatedScale(
                            duration: const Duration(milliseconds: 160),
                            curve: Curves.easeOutCubic,
                            scale: scale,
                            child: Transform.rotate(
                              angle: angle,
                              child: child,
                            ),
                          );
                        },
                        child: icon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
