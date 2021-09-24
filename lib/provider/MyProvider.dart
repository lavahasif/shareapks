import 'package:android_ip/android_ip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shareapks/util/webserver.dart';

import '../shareapk.dart';

class MyProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var _iptext = "";
  var _pageindex = 0;

  get pageindex => _pageindex;

  set pageindex(value) {
    _pageindex = value;
    // print("---------------------->" + value.toString());
    _pagecontroller.jumpToPage(value);
    // _pagecontroller = PageController(initialPage: value);
    notifyListeners();
  }

  var _pagecontroller = PageController(initialPage: 0);

  get pagecontroller => _pagecontroller;

  set pagecontroller(value) {
    print("---------------------->" + value.toString());
    // _pagecontroller = PageController(initialPage: value);
    _pagecontroller.jumpToPage(value);
    // curve: Curves.linear, duration: Duration(milliseconds: 100));
    notifyListeners();
  }

  MyProvider(AndroidIp androidIp) {
    setlistner();
  }

  get iptext => _iptext;
  var _loading = false;

  get loading => _loading;

  set loading(value) {
    _loading = value;
    print("------------->$value");
    notifyListeners();
  }

  share() {
    var da = new AndroidIp().onShared!.listen((event) {
      if (event.toString() == "Progress") {
        print(event.toString());
        loading = true;
      } else {
        print(event.toString());
        loading = false;
      }
    });
  }

  set iptext(value) {
    print("---------------------->" + value);
    _iptext = value;
    // textcontroller.text = value;
    // print("---------------------->"+textcontroller.text);
    notifyListeners();
  }

  var _isloadedSucces = false;

  get isloadedSucces => _isloadedSucces;

  set isloadedSucces(value) {
    _isloadedSucces = value;
  }

  var _wifiip = null;
  var _hotspotip = null;

  get wifiip => _wifiip;

  get hotspotip => _hotspotip;

  set hotspotip(value) {
    _hotspotip = value;
    notifyListeners();
  }

  set wifiip(value) {
    _wifiip = value;
    notifyListeners();
  }

  var _myip = null;

  get myip => _myip;

  set myip(value) {
    _myip = value;
    print(value);
    notifyListeners();
  }

  setlistner() {
    androidIp.onConnectivityChanged!.listen((event) {
      AndroidIp.networkresult.then((value) {
        print(value!.wifi);
        var wifiips = value.wifi.toString();
        var hotspotips = value.wifi_tether.toString();
        if (wifiips != "null") {
          stopserver();
          print('1 ${wifiip}');
          print(value.wifi);
          myip = wifiips;
          StrartServer(wifiips, 12345);
        } else if (hotspotips != "Null") {
          stopserver();
          myip = hotspotips;
          print("2 ${hotspotips}");
          StrartServer(hotspotips, 12345);
        } else {
          stopserver();
          myip = null;
          print("3 ");
        }
      });
    });
  }

  void stopserver() {
    try {
      if (server != null) server?.close(force: true);
    } catch (e) {
      print(e);
    }
  }
}
