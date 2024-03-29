import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/models/user.dart';
import '../../app/networking/dio/base_api_service.dart';

class UserApiService extends BaseApiService {
  UserApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  ///Sign up new User
  Future<User?> signUp({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/auth/signup", data: data),
    );
  }

  ///Sign in user
  Future<User?> signIn({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/auth/signin", data: data),
    );
  }

  ///Request for new OTP
  Future<dynamic> resendOtp() async {
    return await network(
      request: (request) => request.get("/auth/resend-otp"),
    );
  }

  ///Verify OTP
  Future<dynamic> verifyOtp({dynamic query}) async {
    return await network(
      request: (request) =>
          request.post("/auth/validate-email", queryParameters: query),
    );
  }

  ///Check email availability
  Future<dynamic> checkEmail({dynamic query}) async {
    return await network(
      request: (request) =>
          request.post("/auth/check-email", queryParameters: query),
    );
  }

  ///Add Contact Links to account
  Future<dynamic> addContactLinks({dynamic data}) async {
    return await network(
      request: (request) => request.put("/user/", data: data),
    );
  }

  ///Get user details
  Future<dynamic> getuserDetails() async {
    return await network(
      request: (request) => request.get("/user/"),
    );
  }

  ///Find a User
  Future<User?> find({required int id}) async {
    return await network<User>(
      request: (request) => request.get("/endpoint-path/$id"),
    );
  }

  ///Update user passowrd
  Future<User?> editPassword({dynamic data}) async {
    return await network<User>(
      request: (request) => request.put("/user/edit-password", data: data),
    );
  }

  /// Update a User
  Future<User?> update({dynamic data}) async {
    return await network<User>(
      request: (request) => request.put("/user", data: data),
    );
  }

  ///Check password
  Future<User?> checkPassword({dynamic query}) async {
    return await network<User>(
      request: (request) =>
          request.put("/user/check-password", queryParameters: query),
    );
  }

  /// Delete a User
  Future<User?> delete({dynamic data}) async {
    return await network<User>(
      request: (request) => request.delete("/user/delete", data: data),
    );
  }

  Future<dynamic> createPaymentIntent({dynamic data}) async {
    return await network(
      request: (request) =>
          request.post("/stripe/create-payment-intent", data: data),
    );
  }

  Future<dynamic> createBilling() async {
    return await network(
      request: (request) => request.get("/stripe/create-billing"),
    );
  }

  ///Displays Error message
  displayError(DioError dioError, BuildContext context) {
    showToastNotification(
      context,
      title: 'Error',
      description: dioError.response?.data?['message'],
      style: ToastNotificationStyleType.DANGER,
    );
  }
}
