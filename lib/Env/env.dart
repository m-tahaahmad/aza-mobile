class Env {
  static const String apiHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'https://api.azawanpk.com',
  );

  static String apiUrlForTenant(String tenant) {
    final host = apiHost.replaceAll(RegExp(r'/+$'), '');
    final slug = tenant.replaceAll(RegExp(r'^/+|/+$'), '');
    return '$host/api/v1/$slug/';
  }
}
