class ApiErrorCodes {
  static const String mobileAppDisabled = 'mobile_app_disabled';
  static const String tenantBlocked = 'tenant_blocked';
  static const String tenantSuspended = 'tenant_suspended';
  static const String subscriptionInactive = 'subscription_inactive';
  static const String subscriptionCancelled = 'subscription_cancelled';
  static const String subscriptionPastDue = 'subscription_past_due';
  static const String trialEnded = 'trial_ended';

  static const Set<String> accessDeniedCodes = {
    mobileAppDisabled,
    tenantBlocked,
    tenantSuspended,
    subscriptionInactive,
    subscriptionCancelled,
    subscriptionPastDue,
    trialEnded,
  };

  static bool isAccessDenied(String? code) {
    if (code == null || code.isEmpty) {
      return false;
    }
    return accessDeniedCodes.contains(code);
  }
}
