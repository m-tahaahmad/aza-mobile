import 'package:flutter/material.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/constants/font_sizes.dart';

Widget workflowLoadMessage(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: FontSizes.normalText1,
          color: const Color(0xFF667085),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// Loader while a workflow future is in flight, and a visible message when it fails.
Widget workflowAsyncBody({
  required AsyncSnapshot<Object?> snapshot,
  required Widget Function() ready,
  String fallback = 'Failed to load.',
}) {
  if (snapshot.connectionState != ConnectionState.done) {
    return const Center(child: AppLoader());
  }

  if (snapshot.hasError) {
    final error = snapshot.error;
    debugPrint('Workflow load failed: $error\n${snapshot.stackTrace}');
    ClientErrorReporter.report(
      kind: ClientErrorKind.client,
      userVisibleMessage: fallback,
      originalMessage: error?.toString(),
      exceptionClass: error?.runtimeType.toString(),
      stackTrace: snapshot.stackTrace?.toString(),
    );
    return workflowLoadMessage(fallback);
  }

  final data = snapshot.data;
  if (data == null) {
    debugPrint('Workflow load returned no data');
    ClientErrorReporter.report(
      kind: ClientErrorKind.client,
      userVisibleMessage: fallback,
      originalMessage: 'Response was null',
      exceptionClass: 'Mobile.EmptyResponse',
    );
    return workflowLoadMessage(fallback);
  }

  if (data is List) {
    final results = <ApiResponse<dynamic>?>[];
    for (final item in data) {
      if (item != null && item is! ApiResponse) {
        return ready();
      }
      results.add(item as ApiResponse<dynamic>?);
    }
    final failed = results.any((response) => response?.status != Status.completed);
    if (failed) {
      final message = results
          .where((response) => response?.status == Status.error)
          .map((response) => response?.message)
          .whereType<String>()
          .where((message) => message.isNotEmpty)
          .firstOrNull;
      return workflowLoadMessage(message ?? fallback);
    }
    return ready();
  }

  if (data is ApiResponse) {
    if (data.status != Status.completed) {
      final message = data.message;
      return workflowLoadMessage(message == null || message.isEmpty ? fallback : message);
    }
  }

  return ready();
}

/// Loading or error widget, or null when [snapshot] is ready to render.
Widget? workflowAsyncGate({
  required AsyncSnapshot<Object?> snapshot,
  String fallback = 'Failed to load.',
}) {
  var ready = false;
  final body = workflowAsyncBody(
    snapshot: snapshot,
    fallback: fallback,
    ready: () {
      ready = true;
      return const SizedBox.shrink();
    },
  );
  if (ready) return null;
  return body;
}
