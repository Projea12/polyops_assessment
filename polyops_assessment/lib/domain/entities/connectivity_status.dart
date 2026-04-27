enum ConnectivityStatus {
  live,
  /// Online but WebSocket is unavailable — heartbeat GET fallback is active.
  heartbeat,
  /// No network connectivity (or reachability probe failed).
  offline,
}
