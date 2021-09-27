# shareapks
[![pub package](https://img.shields.io/pub/v/shareapks.svg)](https://pub.dev/packages/shareapks)

**A flutter plugin for share you app to other device through wi-fi or other interface(Heavily inspired from xender)!** </br>

*Note*: This plugin is only work in Android device .
## Usage:

### Add dependency：
Please check the latest version before installation.
If there is any problem with the new version, please use the previous version
```yaml
dependencies:
  flutter:
    sdk: flutter
  # add shareapks
  shareapks: ^{latest version}
```
### Add the following imports to your Dart code:
```dart
import 'package:shareapks/shareapk.dart';
```

#### Widget:
consider using  `if (io.Platform.isAndroid)` because it works only android device
```dart
Share()
```
##### Example :
```dart
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shareapks/shareapk.dart';

void main() => runApp(Material(child: MaterialApp(home: start())));

class start extends StatelessWidget {
  const start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => shareme()));
          },
          child: Text("Share"),
        )),
      ),
    );
  }
}

class shareme extends StatelessWidget {
  const shareme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [if (io.Platform.isAndroid) Share()],
        ),
      ),
    );
  }
}

```

![Untitled Project3](https://user-images.githubusercontent.com/22430922/134879148-3fdcabcd-4550-4778-960b-e6d8bc37b098.gif)

#### Api
```
 Shareapks.onShared?.listen((event) {
                  if (event == "Finished")
                  {
                  }
                  else{
                  }
                  });
```

##### Example :
```dart 
import 'dart:io' as io;

import 'package:android_util/android_ip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shareapks/shareapk.dart';
import 'package:shareapks/shareapks.dart';

void main() => runApp(Material(child: MaterialApp(home: start())));

class start extends StatefulWidget {
  const start({Key? key}) : super(key: key);

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {
  Widget _mywidget = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _mywidget,
          Container(
            child: Center(
                child: ElevatedButton(
              onPressed: () {
                Shareapks.onShared?.listen((event) {
                  if (event == "Finished")
                    setState(() {
                      _mywidget = Container(child: Text("Finished"));
                    });
                  else
                    setState(() {
                      _mywidget = CircularProgressIndicator();
                    });
                });
              },
              child: Text("Send Me"),
            )),
          ),
        ],
      ),
    );
  }
}
```

![Untitled Project](https://user-images.githubusercontent.com/22430922/134873510-585c1bbb-1e76-4679-8bd4-92d0cf6f0251.gif)

#### Problem And solution
problem 1: After sharing apk file it coud'nt install? 

solution :You must build apk by flutter build apk --split-per-abi Because debug file coud'nt install on other device


#### Reference
1. Flaticon   (Icon)
2. Xender (Inspired)
