import 'package:flutter_test/flutter_test.dart';
import 'package:icms_app/Services/API/api_error_parser.dart';

void main() {
  const botVerificationHtml = '''
<!DOCTYPE html>
<html>
<head><title>Bot Verification</title></head>
<body>
<script src="https://www.google.com/recaptcha/api.js"></script>
</body>
</html>
''';

  test('bot verification HTML becomes a short blocked message', () {
    final parsed = ApiErrorParser.parse(botVerificationHtml);

    expect(parsed.message, 'Request blocked. Please try again.');
    expect(parsed.message.contains('<'), isFalse);
  });

  test('other HTML becomes a generic error', () {
    const html = '<html><body><h1>502 Bad Gateway</h1></body></html>';

    expect(ApiErrorParser.parse(html).message, 'Something went wrong');
  });

  test('JSON message is kept', () {
    final parsed = ApiErrorParser.parse('{"message":"Invalid credentials","code":"INVALID"}');

    expect(parsed.message, 'Invalid credentials');
    expect(parsed.code, 'INVALID');
  });

  test('JSON error.message is kept', () {
    final parsed = ApiErrorParser.parse(
      '{"error":{"message":"Access denied","code":"ACCESS_DENIED","reason":"role"}}',
    );

    expect(parsed.message, 'Access denied');
    expect(parsed.code, 'ACCESS_DENIED');
    expect(parsed.reason, 'role');
    expect(
      ApiErrorParser.displayMessage(parsed),
      'Access denied Reason: role',
    );
  });

  test('displayMessage leaves errors without a reason unchanged', () {
    const parsed = ParsedApiError(message: 'Username/Password is not correct.');

    expect(ApiErrorParser.displayMessage(parsed), 'Username/Password is not correct.');
  });

  test('short plain text is kept', () {
    expect(ApiErrorParser.parse('Unauthorized').message, 'Unauthorized');
  });

  test('sanitizeForDisplay replaces embedded HTML and leaves plain text', () {
    expect(
      ApiErrorParser.sanitizeForDisplay('FormatException\n$botVerificationHtml'),
      'Request blocked. Please try again.',
    );
    expect(ApiErrorParser.sanitizeForDisplay('Details are missing'), 'Details are missing');
  });
}
