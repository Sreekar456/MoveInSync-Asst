import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  Future<bool> checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      // No internet connection
      if(!context.mounted) return false;
      displaySnackbar("Internet is not connected", context);
    }
    // Connected to either mobile or wifi
    return true;
  } 
  displaySnackbar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}