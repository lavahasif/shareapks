import 'package:android_ip/android_ip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  MyProvider();

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
}
