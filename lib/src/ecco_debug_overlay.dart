import 'package:flutter/material.dart';
import 'package:ecco/ecco.dart';

/// A widget that provides a debug overlay for Ecco notifiers.
///
/// This widget wraps a child widget and adds a floating action button
/// that toggles the visibility of a debug overlay. The overlay displays
/// information about all registered Ecco notifiers.
class EccoDebugOverlay extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates an [EccoDebugOverlay].
  ///
  /// The [child] argument must not be null.
  const EccoDebugOverlay({
    super.key,
    required this.child,
  });

  @override
  State<EccoDebugOverlay> createState() => _EccoDebugOverlayState();
}

/// The state for [EccoDebugOverlay].
class _EccoDebugOverlayState extends State<EccoDebugOverlay> {
  /// Whether the debug overlay is currently visible.
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to update the state when debug information changes.
    EccoDebug.instance.addListener(_handleDebugUpdate);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed.
    EccoDebug.instance.removeListener(_handleDebugUpdate);
    super.dispose();
  }

  /// Callback for when debug information is updated.
  ///
  /// This method triggers a rebuild of the widget.
  void _handleDebugUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // The main content of the app
          widget.child,
          // The debug overlay, only shown when _showOverlay is true
          if (_showOverlay)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 200,
              child: Material(
                color: Colors.black.withOpacity(0.8),
                child: ListView(
                  children: EccoDebug.instance.getNotifiersData().map(
                    (notifier) {
                      return ListTile(
                        title: Text(
                          notifier['type'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          notifier['state'],
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          // The button to toggle the debug overlay
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showOverlay = !_showOverlay;
                });
              },
              child: Icon(
                _showOverlay ? Icons.close : Icons.bug_report,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
