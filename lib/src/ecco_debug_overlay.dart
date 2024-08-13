import 'package:flutter/material.dart';

import 'package:ecco/ecco.dart';

class EccoDebugOverlay extends StatefulWidget {
  final Widget child;

  const EccoDebugOverlay({
    super.key,
    required this.child,
  });

  @override
  State<EccoDebugOverlay> createState() => _EccoDebugOverlayState();
}

class _EccoDebugOverlayState extends State<EccoDebugOverlay> {
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    EccoDebug.instance.addListener(_handleDebugUpdate);
  }

  @override
  void dispose() {
    EccoDebug.instance.removeListener(_handleDebugUpdate);
    super.dispose();
  }

  void _handleDebugUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          widget.child,
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
