import 'package:flutter/material.dart';

import '../../../domain/entities/connectivity_status.dart';

class ConnectivityBanner extends StatelessWidget {
  final ConnectivityStatus status;
  const ConnectivityBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, icon, text, textColor) = switch (status) {
      ConnectivityStatus.live => (
          const Color(0xFFECFDF5),
          Icons.wifi_rounded,
          'Live updates active',
          const Color(0xFF065F46),
        ),
      ConnectivityStatus.heartbeat => (
          const Color(0xFFFFFBEB),
          Icons.wifi_find_rounded,
          'Checking for updates…',
          const Color(0xFF92400E),
        ),
      ConnectivityStatus.offline => (
          const Color(0xFFFEF2F2),
          Icons.wifi_off_rounded,
          'You\'re offline — updates paused',
          const Color(0xFF991B1B),
        ),
    };

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: status == ConnectivityStatus.live
          ? const SizedBox.shrink()
          : Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              color: bg,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
