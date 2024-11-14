import 'dart:async';

import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';

extension UmrApi on RenewApi {
  Future<ApiUserData> getUserData() async {
    return ApiUserData.fromJson(await get('v1/umr/user_info'));
  }

  Future<ApiCode> scan({ required String code }) async {
    return ApiCode.fromJson(await post('v1/umr/scan', dataGenerator: () => { 'code': code }));
  }
}
