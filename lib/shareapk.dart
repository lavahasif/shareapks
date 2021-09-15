library shareapk;



import 'package:android_ip/android_ip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'MyProvider.dart';

class SharePage extends StatelessWidget {
  SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: QrImage(
            data: "1234567890",
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Scan the QR code to download the app or type the address in other device browser"),
          ),
        ),
        TextField(
          readOnly: true,
          controller: _ipcontroller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => _copyaddress(),
              icon: Icon(Icons.copy, size: 28),
            ),
            border: OutlineInputBorder(),
            hintText: '',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 63,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () => context.read<MyProvider>().share(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text("Share"),
                ],
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => {context.read<MyProvider>().pageindex = 1},
          child: RichText(
            text: TextSpan(
              text: 'Instruction? ',
              style: DefaultTextStyle.of(context).style,
              children: const <TextSpan>[
                TextSpan(
                    text: 'Help',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
        )
      ],
    );
  }

  setShare(BuildContext context) {
    var da = new AndroidIp().onShared!.listen((event) {
      if (event.toString() == "Progress") {
        print(event.toString());
        context.read<MyProvider>().loading = true;
      } else {
        print(event.toString());
        context.read<MyProvider>().loading = false;
      }
    });
  }

  _copyaddress() {}
  var _ipcontroller = TextEditingController();
}

class Instruction extends StatelessWidget {
  const Instruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Instruction for other devices',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
            Component("1 . ", "Connect to the same Wi-Fi", "assets/img.png"),
            Component(
                "2 . ", "Open the device's web browser", "assets/img.png"),
            Component("3 . ", "Input the following address", "assets/img.png",
                text3: "192.168.43.84"),
            SizedBox(
              height: 125,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 125,
            child: OutlinedButton(
              onPressed: () => {context.read<MyProvider>().pageindex = 0},
              child: RichText(
                text: TextSpan(
                    text: 'Back',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PageViews extends StatelessWidget {
  const PageViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 2,

      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      scrollDirection: Axis.horizontal,
      controller: context.watch<MyProvider>().pagecontroller,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Stack(
            children: [
              context.watch<MyProvider>().loading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : Container(),
              SharePage(),
            ],
          );
        else
          return Instruction();
      },
    );
  }


}

class Share extends StatelessWidget {
  const Share({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MyProvider(), child: PageViews());
  }
}

class Component extends StatelessWidget {
  var image;

  var text1;

  var text2;

  var text3;

  Component(this.text1, this.text2, this.image, {Key? key, this.text3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    text3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(6.0),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: text2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                  text: text1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            )),
        if (text3.toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: text3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.cyan)),
                  ],
                  text: "  ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          )
        // ConstrainedBox(
        //   constraints: BoxConstraints(maxWidth: double.infinity),
        //   child: Card(
        //     child: Image.asset(image),
        //     elevation: 4,
        //   ),
        // )
      ],
    );
  }
}
