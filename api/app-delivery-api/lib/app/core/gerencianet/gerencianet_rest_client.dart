import 'dart:io';

import 'package:app_delivery_api/app/core/gerencianet/gerencianet_auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dotenv/dotenv.dart';

class GerenciaNetRestClient extends DioForNative {
  static final _baseOptions = BaseOptions(
      baseUrl: env['GERENCIANET_URL'] ?? env['gerencianetUrl'] ?? '',
      connectTimeout: 60000,
      receiveTimeout: 60000);

  GerenciaNetRestClient() : super(_baseOptions) {
    _configureCertificates();
    interceptors.add(LogInterceptor(responseBody: true));
  }

  GerenciaNetRestClient auth() {
    interceptors.add(GerencianetAuthInterceptor());
    return this;
  }

  void _configureCertificates() {
    httpClientAdapter =
        Http2Adapter(ConnectionManager(onClientCreate: (uri, config) {
      final pathCRT = env['GERENCIANET_CERTIFICADO_CRT'] ??
          env['gerencianetCertificadoCRT'] ??
          '';
      final pathKEY = env['GERENCIANET_CERTIFICADO_KEY'] ??
          env['gerencianetCertificadoKey'] ??
          '';

      final root = Directory.current.path;
      final securityContext = SecurityContext(withTrustedRoots: true);

      securityContext.useCertificateChain('$root/$pathCRT');
      securityContext.usePrivateKey('$root/$pathKEY');
      config.context = securityContext;
    }));
  }
}
