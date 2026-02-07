import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/features/Dashboard/views/DashboardView.dart';
import 'package:SaloonySpecialist/features/Salon/views/AppointmentsScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/TeamMembersScreen.dart';
import 'package:SaloonySpecialist/features/Salon/views/team_members_list_view.dart';
import 'package:SaloonySpecialist/features/auth/views/VerifyEmailWidget.dart';
import 'package:SaloonySpecialist/features/auth/views/VerifyResetCodeWidget.dart';
import 'package:SaloonySpecialist/features/Salon/views/DisponibiliteView.dart';
import 'package:SaloonySpecialist/features/profile/views/ChangeEmailView.dart';
import 'package:SaloonySpecialist/features/profile/views/HelpCenterScreen.dart';
import 'package:SaloonySpecialist/features/profile/views/PrivacyPolicyScreen.dart';
import 'package:SaloonySpecialist/features/profile/views/ProfileEditView.dart';
import 'package:SaloonySpecialist/features/profile/views/ResetPasswordView.dart';
import 'package:SaloonySpecialist/features/profile/views/SalonProfileView.dart';
import 'package:SaloonySpecialist/features/splash/splash_page.dart';
import 'package:SaloonySpecialist/features/Salon/views/salon_creation_pages.dart';
import '../../features/auth/views/ForgotPasswordWidget.dart';
import '../../features/auth/views/LinkSentWidget.dart';
import '../../features/auth/views/ResetPasswordWidget.dart';
import '../../features/auth/views/SignInWidget.dart';
import '../../features/auth/views/SignUpWidget.dart';
import '../../features/auth/views/SuccessResetWidget.dart';

class AppRoutes {
  static const String signIn = '/signIn';
  static const String splash = '/splash';
  static const String TeamMembersScreen = '/teamMembers';
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
  static const String HelpCenterScreen = '/faq';
  static const String PrivacyPolicy = '/PrivacyPolicy';
  static const String salonCreation = '/salon/create';
  static const String verifyEmail = '/verifyEmail';
  static const String verifyResetCode = '/verifyResetCode';
  static const String createsalon = '/createsalon';
  static const String teamMembers = '/teamMembers';
  static const String Appointments = '/Appointments';
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
  HelpCenterScreen: (_) => const HelpCenterScreenP(),
  ChangeEmail: (_) => const VerifyEmailChangeView(),
  verifyResetCode: (_) => const VerifyResetCodeWidget(),
  editProfile : (_) => const ProfileEditView(),
  home: (_) => DashboardView(), 
  createsalon: (_) => const SalonCreationFlow(),
   PrivacyPolicy: (_) => const PrivacyPolicyScreen(),
   Appointments: (_) => const AppointmentsScreen(),


};

}
