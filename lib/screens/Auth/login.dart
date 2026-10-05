import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:icms_app/Model/Users/users_list_model.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/auth/auth_primary_button.dart';
import 'package:icms_app/components/auth/auth_text_field.dart';
import 'package:icms_app/components/auth/quick_signin_pill.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/constants/asset_constants.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/DashBoard/dashboard.dart';
import 'package:icms_app/Services/SettingService/public_settings_storage.dart';
import 'package:icms_app/Services/SettingService/setting_service.dart';
import 'package:icms_app/Services/TenantConfig/tenant_config.dart';

import '../../Model/Auth/login_request_model.dart';
import '../../Services/AuthServices/login_services.dart';
import '../../Services/AuthServices/token_storage.dart';
import '../../Services/SharedPreferenceService/shared_preferences_service.dart';
import '../../constants/keys_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool rememberMe = false;
  bool obscurePassword = true;
  List<LoginRequestModel> loggedInUsers = [];
  List<LoginRequestModel> suggestedUsers = [];
  String _appVersion = '1.0.1';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadRememberedCredentials();
    _loadSavedServerName();
  }

  Future<void> _loadSavedServerName() async {
    final serverName = await TenantConfig.getServerName();
    if (!mounted) return;
    if (serverName != null && serverName.isNotEmpty) {
      serverController.text = serverName;
      setState(() {});
    }
  }

  Future<void> _loadRememberedCredentials() async {
    final value =
        await SharedPreferencesService().getString(KeysConstants.rememberMe);
    if (value == "isRemembered") {
      rememberMe = true;
      userNameController.text =
          (await SharedPreferencesService().getString(KeysConstants.userName))!;
      passwordController.text =
          (await SharedPreferencesService().getString(KeysConstants.password))!;
      final usersJson = await SharedPreferencesService()
          .getString(KeysConstants.authCredentials);
      if (usersJson != null) {
        final users = jsonDecode(usersJson) as Map<String, dynamic>;
        final usersList = UsersListModel.fromJson(users);
        if (usersList.data != null && usersList.data!.isNotEmpty) {
          loggedInUsers = usersList.data!;
          suggestedUsers = List.from(loggedInUsers);
        }
      }
      setState(() {});
    }
  }

  void _selectUser(LoginRequestModel user) {
    setState(() {
      userNameController.text = user.username ?? '';
      passwordController.text = user.password ?? '';
    });
  }

  bool _isUserSelected(LoginRequestModel user) {
    return userNameController.text.trim() == (user.username ?? '').trim();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    serverController.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.trim();
      final build = info.buildNumber.trim();
      if (!mounted || version.isEmpty) return;
      setState(() {
        _appVersion = build.isNotEmpty ? '$version+$build' : version;
      });
    } catch (e) {
      debugPrint('Failed to load app version: $e');
    }
  }

  Future<void> _openBitDataStudio() async {
    final uri = Uri.parse('https://bitdatastudio.com');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      showSnackBar(context, 'Could not open link');
    }
  }

  Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: FontSizes.extraSmallText,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9CA3AF),
              ),
              children: [
                const TextSpan(text: 'Powered by '),
                TextSpan(
                  text: 'Bit Data Studio',
                  style: TextStyle(
                    color: ColorConstants.primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _openBitDataStudio,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'v$_appVersion',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSizes.smallText,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.asset(
              AssetConstants.surveySnapLogo,
              width: 120.w,
              height: 120.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Welcome back',
            style: TextStyle(
              fontSize: FontSizes.extraLargeText,
              fontWeight: FontWeight.w800,
              color: ColorConstants.black,
              height: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Sign in to continue your field surveys.',
            style: TextStyle(
              fontSize: FontSizes.normalText1,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.3,
            ),
          ),
          if (suggestedUsers.isNotEmpty) ...[
            SizedBox(height: 18.h),
            Text(
              'QUICK SIGN-IN',
              style: TextStyle(
                fontSize: FontSizes.extraSmallText,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 48.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedUsers.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final user = suggestedUsers[index];
                  return AuthQuickSignInPill(
                    name: user.username ?? '',
                    isSelected: _isUserSelected(user),
                    colorIndex: index,
                    onTap: () => _selectUser(user),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 18.h),
          AuthTextField(
            hintText: 'Username',
            controller: userNameController,
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.none,
            prefixIcon: Icon(
              CupertinoIcons.person,
              color: const Color(0xFF9CA3AF),
              size: 18.sp,
            ),
            onChanged: (_) => setState(() {}),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter Username' : null,
          ),
          SizedBox(height: 14.h),
          AuthTextField(
            hintText: 'Password',
            controller: passwordController,
            isObscure: obscurePassword,
            inputType: TextInputType.visiblePassword,
            inputAction: TextInputAction.next,
            prefixIcon: Icon(
              CupertinoIcons.lock,
              color: const Color(0xFF9CA3AF),
              size: 18.sp,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                color: const Color(0xFF9CA3AF),
                size: 18.sp,
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter Password' : null,
          ),
          SizedBox(height: 14.h),
          AuthTextField(
            hintText: 'Server',
            controller: serverController,
            inputType: TextInputType.text,
            inputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            prefixIcon: Icon(
              Icons.dns,
              color: const Color(0xFF9CA3AF),
              size: 18.sp,
            ),
            onFieldSubmit: (_) {
              if (formKey.currentState!.validate()) {
                loginUser();
              }
            },
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Please enter Server'
                : null,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: rememberMe,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeThumbColor: Colors.white,
                  activeTrackColor: ColorConstants.primaryColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value;
                    });
                  },
                ),
              ),
              Text(
                'Remember me',
                style: TextStyle(
                  fontSize: FontSizes.normalText1,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          isLoading
              ? const Center(child: AppLoader())
              : AuthPrimaryButton(
                  title: 'Log in',
                  height: 44.h,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      loginUser();
                    } else {
                      showSnackBar(context, 'One or more field is Empty');
                    }
                  },
                ),
          SizedBox(height: 20.h),
          _buildFooter(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.baseColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 32.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoginForm(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  loginUser() async {
    setState(() {
      isLoading = true;
    });

    final serverName = serverController.text.trim();
    await TenantConfig.saveServerName(serverName);

    if (!mounted) return;

    try {
      final value = await LoginServices().login(
        context,
        username: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (value != null && value.success == true) {
        if (rememberMe) {
          if (loggedInUsers.isEmpty ||
              !loggedInUsers.any((element) =>
                  element.username == userNameController.text.trim())) {
            loggedInUsers.add(LoginRequestModel(
                username: userNameController.text.trim(),
                password: passwordController.text.trim()));
          }
          var usersList = UsersListModel(data: loggedInUsers);
          await SharedPreferencesService()
              .setString(KeysConstants.rememberMe, 'isRemembered');
          await SharedPreferencesService()
              .setJsonString(KeysConstants.authCredentials, usersList.toJson());
          await SharedPreferencesService().setString(
              KeysConstants.userName, userNameController.text.trim());
          await SharedPreferencesService().setString(
              KeysConstants.password, passwordController.text.trim());
        } else {
          await SharedPreferencesService().remove(KeysConstants.rememberMe);
          await SharedPreferencesService().remove(KeysConstants.userName);
          await SharedPreferencesService().remove(KeysConstants.password);
          if (loggedInUsers.any((element) =>
              element.username == userNameController.text.trim())) {
            loggedInUsers.removeWhere((element) =>
                element.username == userNameController.text.trim());
            var usersList = UsersListModel(data: loggedInUsers);
            await SharedPreferencesService().setJsonString(
                KeysConstants.authCredentials, usersList.toJson());
          }
        }
        await TokenStorage.setTokens(
          value.data!.accessToken ?? '',
          refreshToken: value.data!.refreshToken,
        );
        await SharedPreferencesService()
            .setString(KeysConstants.userId, value.data!.user!.id.toString());
        await SharedPreferencesService().setString(
            KeysConstants.userableId, value.data!.user!.userableId.toString());
        await SharedPreferencesService().setString(
            KeysConstants.zoneId, value.data!.user!.zoneId.toString());
        userId = value.data!.user!.id.toString();
        userableId = value.data!.user!.userableId.toString();
        zoneId = value.data!.user!.zoneId.toString();
        await SharedPreferencesService()
            .setString(KeysConstants.isUserLogin, "true");

        final settings = await SettingService().fetchPublicSettings();
        if (settings != null) {
          await PublicSettingsStorage.save(settings);
          ColorConstants.applyFromPublicSettings(settings);
        } else if (mounted) {
          showSnackBar(
              context, 'Could not load tenant settings. Using default theme.');
        }

        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const DashboardScreen();
        }));
      } else if (value != null &&
          value.error != null &&
          value.error!.message != null) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, value.error!.message.toString());
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "Something went wrong!!!");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Something went wrong!!!');
    }
  }
}
