import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/global/global_var.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    try {
      // Read the service account credentials from the root directory
      final file = File('service_account.json');
      if (!await file.exists()) {
        throw Exception("Missing service_account.json in project root.");
      }

      final String jsonString = await file.readAsString();
      final Map<String, dynamic> serviceAccountJson = jsonDecode(jsonString);

      List<String> scopes = [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/firebase.database",
        "https://www.googleapis.com/auth/firebase.messaging",
      ];

      final auth.ServiceAccountCredentials credentials =
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      final http.Client client = await auth.clientViaServiceAccount(
        credentials,
        scopes,
      );

      final auth.AccessCredentials accessCredentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        credentials,
        scopes,
        client,
      );

      client.close();

      return accessCredentials.accessToken.data;
    } catch (e) {
      print("Failed to obtain access token: $e");
      rethrow;
    }
  }

  static Future<void> sendNotificationToSelectedDriver(
    String deviceToken,
    BuildContext context,
    String tripID,
  ) async {
    try {
      print('Device token: $deviceToken');

      String dropOffDestinationAddress =
          Provider.of<AppInfoClass>(context, listen: false)
              .dropOffLocation!
              .placeName
              .toString();

      String pickUpAddress = Provider.of<AppInfoClass>(context, listen: false)
          .pickUpLocation!
          .placeName
          .toString();

      print('Pickup address: $pickUpAddress');

      final String accessToken = await getAccessToken();

      String fcmEndpoint =
          "https://fcm.googleapis.com/v1/projects/everyone-2de50/messages:send";

      final Map<String, dynamic> message = {
        'message': {
          'token': deviceToken,
          'notification': {
            'title': "New Trip Request From $userName",
            'body':
                "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDestinationAddress"
          },
          'data': {
            'tripID': tripID,
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
