final Map<String, int> scores = {'Alice': 95, 'Bob': 82};

void main(List<String> args) {
  // Iterating over keys
  for (final String key in scores.keys) {
    print(key);
  }

  // Iterating over values
  for (final int value in scores.values) {
    print(value);
  }

  // Iterating over key-value pairs
  for (final MapEntry<String, int> entry in scores.entries) {
    print('${entry.key}: ${entry.value}');
  }

  // (x, y) coordinates
  final (dynamic, int)? point = ('adf', 20);

  // print(point.$1);

  final List<String> telemetry = [
    'Device 01',
    if (point case (final String x, final y)) 'Coordinates: $x, $y',
  ];

  print(telemetry);
  // Output: [Device 01, Coordinates: 10, 20]

  final String? optionalRole = 'lead_developer';
  final Object rawStatus = 200;

  final List<String> userBadges = [
    'Member',
    // Matches and binds only if optionalRole is not null
    if (optionalRole case final String role) 'Role: $role',

    // Matches only if rawStatus is an int
    if (rawStatus case final int code) 'Status Code: $code',
  ];

  print(userBadges);
  // Output: [Member, Role: lead_developer, Status Code: 200]
}
