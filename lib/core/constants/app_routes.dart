import 'package:flutter/material.dart';
import 'package:saloony/features/Dashboard/views/DashboardView.dart';
import 'package:saloony/features/auth/views/VerifyEmailWidget.dart';
import 'package:saloony/features/auth/views/VerifyResetCodeWidget.dart';
import 'package:saloony/features/profile/views/ChangeEmailView.dart';
import 'package:saloony/features/profile/views/ProfileEditView.dart';
import 'package:saloony/features/profile/views/ResetPasswordView.dart';
import 'package:saloony/features/profile/views/SalonProfileView.dart';
import 'package:saloony/features/splash/splash_page.dart';

import '../../data/models/user_model.dart';
import '../../features/auth/views/ForgotPasswordWidget.dart';
import '../../features/auth/views/LinkSentWidget.dart';
import '../../features/auth/views/ResetPasswordWidget.dart';
import '../../features/auth/views/SignInWidget.dart';
import '../../features/auth/views/SignUpWidget.dart';
import '../../features/auth/views/SuccessResetWidget.dart';

class AppRoutes {
  static const String signIn = '/signIn';
  static const String splash = '/splash';

  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String linkSent = '/linkSent';
  static const String resetPassword = '/resetPassword';
  static const String successReset = '/successReset';
  static const String home = '/home';
  static const String profile = '/profile';
    static const String editProfile = '/editProfile';
     static const String ResetPasswordP = '/ResetPasswordP';
          static const String ChangeEmail = '/ChangeEmail';


static const String verifyEmail = '/verifyEmail';
static const String verifyResetCode = '/verifyResetCode';

 static Map<String, WidgetBuilder> routes = {
  signIn: (_) => const SignInWidget(),
  splash: (_) => const SaloonySplashPage(),
  signUp: (_) => const SignUpWidget(),
  forgotPassword: (_) => const ForgotPasswordWidget(),
  linkSent: (_) => const LinkSentWidget(),
  resetPassword: (_) => ResetPasswordWidget(),
  successReset: (_) => const SuccessResetWidget(),
  profile: (_) => const ProfileView(),
  verifyEmail: (_) => const VerifyEmailWidget(),
    ResetPasswordP: (_) => const ResetPasswordView(),
        ChangeEmail: (_) => const ChangeEmailView(),


  verifyResetCode: (_) => const VerifyResetCodeWidget(),
editProfile : (_) => const ProfileEditView(),
  home: (_) => DashboardView(), 
};

}
