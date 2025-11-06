import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHelper {
  static Map<String, dynamic>? decodeToken(String? token) {
    if (token == null || token.isEmpty) return null;
    return JwtDecoder.decode(token);
  }

  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    return JwtDecoder.isExpired(token);
  }

  static DateTime? getExpirationDate(String? token) {
    if (token == null || token.isEmpty) return null;
    return JwtDecoder.getExpirationDate(token);
  }

  static String? getClaim(String? token, String claimKey) {
    final decoded = decodeToken(token);
    return decoded != null ? decoded[claimKey]?.toString() : null;
  }
}
