import 'dart:io';
import 'dart:typed_data';

import 'package:android_util/android_ip.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart' as hp;
import 'package:mime/mime.dart' as mime;
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as r;
import 'package:shelf_static/shelf_static.dart';

late HttpServer? server = null;
late r.Router app;

Future<void> Initial() async {
  initializeDatabase();

  final Directory? docDir = await getExternalStorageDirectory();

  app = Routers();

  app.mount("/", createStaticHandler(docDir!.path));
  var address = "";
  var port = 12345;

  // StrartServer("192.168.62.229", 123);
}

Future<void> StrartServer(String address, int port) async {
  try {
    server = await shelf_io.serve(Cascade().add(app).handler, address, port);

    server!.autoCompress = true;

    print('Serving at http://${server!.address.host}:${server!.port}');
  } on SocketException catch (_, e) {
    var istrue = _.osError!.errorCode == 98;
    if (istrue) {
      stopserver();
      server = null;
    }
  }
}

void stopserver() {
  try {
    if (server != null) server?.close(force: true);
  } catch (e) {
    print(e);
  }
}

r.Router Routers() {
  var app = r.Router();
  app.get('/home', (Request request) async {
    var data = await AndroidIp.getAppName;
    final imageBytes =
        await rootBundle.loadString("packages/shareapks/asset/index.html");
    var datas = imageBytes.replaceAll('app_sha', data!);

    File fi = await writeToFile2(datas, "index.html");
    final headers = await _defaultFileheaderParser(fi);
  });
  app.get('/', (Request request) async {
    var data = await AndroidIp.getAppName;
    final imageBytes =
        await rootBundle.loadString("packages/shareapks/asset/index.html");
    var datas = imageBytes.replaceAll('app_sha', data!);

    File fi = await writeToFile2(datas, "index.html");
    final headers = await _defaultFileheaderParser(fi);
    return Response(200, body: fi.openRead(), headers: headers);
  });

  app.get('/files', (Request request) async {
    File fi = await setapp();
    final headers = await _defaultFileheaderParser(fi);
    return Response(200, body: fi.openRead(), headers: headers);
  });

  return app;
}

Future<File> setapp() async {
  final Directory? docDir = await getExternalStorageDirectory();

  var path = docDir!.path;
  var pathf = await AndroidIp.shareAPKFile;
  File fi = File(path + "/app.apk");
  return fi;
}
// r.Router Routers() {
//   var app = r.Router();
//   app.get('/home', (Request request) async {
//     final imageBytes = await rootBundle.load("assets/files/index.html");
//     File fi = await writeToFile(imageBytes, "index.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response(200, body: fi.openRead(), headers: headers);
//   });
//   app.get('/', (Request request) async {
//     final imageBytes = await rootBundle.load("assets/files/index.html");
//     File fi = await writeToFile(imageBytes, "index.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response(200, body: fi.openRead(), headers: headers);
//   });
//
//   app.get('/filess', (Request request) async {
//  var data=await Androidip.
//     final imageBytes = await rootBundle.loadString("packages/shareapks/asset/index.html");
//     var datas = imageBytes.replaceAll("$app_sha", data);
//
//     File fi = await writeToFile2(datas, "index.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response(200, body: fi.openRead(), headers: headers);
//   });
//
//   app.get('/bootstrap', (Request request) async {
//     final imageBytes = await rootBundle.load("assets/files/self.html");
//     File fi = await writeToFile(imageBytes, "self.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response(200, body: fi.openRead(), headers: headers);
//   });
//   app.get('/n404', (Request request) async {
//     final imageBytes = await rootBundle.load("assets/files/404.html");
//     File fi = await writeToFile(imageBytes, "404.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response(200, body: fi.openRead(), headers: headers);
//   });
//   app.get('/api/set/<name>', (Request request, String name) async {
//     final imageBytes = await rootBundle.load("assets/files/self.html");
//     File fi = await writeToFile(imageBytes, "self.html");
//     final headers = await _defaultFileheaderParser(fi);
//     return Response.ok('$name hello Api ${request.requestedUri}');
//   });
//
//   app.get('/u', (Request request, String user) {
//     return Response(200,
//         // body: test.htmls,
//         headers: {HttpHeaders.contentTypeHeader: 'text/html'});
//   });
//   return app;
// }

Future<Map<String, Object>> _defaultFileheaderParser(File file) async {
  final fileType = mime.lookupMimeType(file.path);

  // collect file data
  final fileStat = await file.stat();

  // check file permission
  if (fileStat.modeString()[0] != 'r') return {};

  return {
    HttpHeaders.contentTypeHeader: fileType ?? 'application/octet-stream',
    HttpHeaders.contentLengthHeader: fileStat.size.toString(),
    HttpHeaders.lastModifiedHeader: hp.formatHttpDate(fileStat.modified),
    HttpHeaders.acceptRangesHeader: 'bytes'
  };
}

writeToFile2(String imageBytes, String file) async {
  Directory? tempDir = await getExternalStorageDirectory();
  String? tempPath = tempDir?.path;
  var filePath =
      tempPath! + '/' + file; // file_01.tmp is dump file, can be anything
  return new File(filePath).writeAsString(imageBytes);
}

Future<Response> third(Request request) async {
  List<int> dataBytes = [];
  await for (var data in request.read()) {
    dataBytes.addAll(data);
  }

  String fileExtension = '';
  late File file;
  var header2 = request.headers['content-type'];
  var header = HeaderValue.parse(header2!);
  final transformer =
      new mime.MimeMultipartTransformer(header.parameters['boundary']!);
  final bodyStream = Stream.fromIterable([dataBytes]);
  try {
    final parts = await transformer.bind(bodyStream).toList();
    final part = parts[0];
    if (part.headers.containsKey('content-disposition')) {
      header = HeaderValue.parse(part.headers['content-disposition']!);
      String? filename = header.parameters['filename'] ?? "pic.png";
      final content = await part.toList();
      convert(content[0], filename);
      // originalfilename = header.parameters['filename'];
      // print('originalfilename:' + originalfilename!);
      // fileExtension = p.extension(originalfilename);
      // file = await File('/destination/filename.mp4').create(
      //     recursive:
      //         true); //Up two levels and then down into ServerFiles directory

      // await file.writeAsBytes(content[0]);
      return Response.ok("File Sucesfully Uploaded $filename");
    }
  } catch (e) {
    print(e);
    return Response.notFound(e.toString() + "\n Empty File");
  }
  return Response.notFound("Empty File");
}

Future<void> four(Request request) async {
  List<int> dataBytes = [];
  await for (var data in request.read()) {
    dataBytes.addAll(data);
  }

  String fileExtension = '';
  late File file;
  var header2 = request.headers['content-type'];
  var header = HeaderValue.parse(header2!);
  final transformer =
      new mime.MimeMultipartTransformer(header.parameters['boundary']!);
  transformer.bind(request.read());
  final bodyStream = Stream.fromIterable([dataBytes]);
  final parts = await transformer.bind(bodyStream).toList();
  final part = parts[0];
  if (part.headers.containsKey('content-disposition')) {
    header = HeaderValue.parse(part.headers['content-disposition']!);
    String? filename = header.parameters['filename'] ?? "pic.png";
    final content = await part.toList();

    convert(content, filename);
    // originalfilename = header.parameters['filename'];
    // print('originalfilename:' + originalfilename!);
    // fileExtension = p.extension(originalfilename);
    // file = await File('/destination/filename.mp4').create(
    //     recursive:
    //         true); //Up two levels and then down into ServerFiles directory

    // await file.writeAsBytes(content[0]);
  }
}

void second(Request request) {
  gzip.decoder.bind(request.read()).drain();
}

void convert(dataBytes, String filename) {
  var s = Uint8List.fromList(dataBytes);
  writeToFile(s.buffer.asByteData(), filename);
}

Future<void> fst(Request request) async {
  List<int> dataBytes = [];
  String? value = request.headers['content-type'];
  var header = HeaderValue.parse(value!);
  var boundary = header.parameters['boundary']!;
  await for (var part in request
      .read()
      .transform(new mime.MimeMultipartTransformer(boundary))) {
    if (part.headers.containsKey('content-disposition')) {
      String? header2 = part.headers['content-disposition'];
      header = HeaderValue.parse(header2!);
      Directory? tempDir = await getExternalStorageDirectory();
      String? tempPath = tempDir?.path;
      var filename = tempPath! + '/' + "pics.png";
      final file = new File(filename);
      IOSink fileSink = file.openWrite();
      await part.pipe(fileSink);
      fileSink.close();
    }
    // dataBytes.addAll(data);
  }
}

Response _echoRequest(Request request) =>
    Response.ok('Request for Kunchol "${request.url}"');

Future<void> initializeDatabase() async {
  // copy db file from Assets folder to Documents folder (only if not already there...)
  // if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
  var datab = await rootBundle.load("packages/shareapks/asset/img.png");
  writeToFile(datab, "img.png");
  // var databi = await rootBundle.load("assets/files/bim.html");
  var data = await rootBundle.load("packages/shareapks/asset/index.html");
  // var datas = await rootBundle.load("assets/files/self.html");
  // }
  writeToFile(data, "index.html");
  setapp();
}

//=======================
Future<File> writeToFiles(ByteData data) async {
  final buffer = data.buffer;
  Directory? tempDir = await getExternalStorageDirectory();
  String? tempPath = tempDir?.path;

  var filePath =
      tempPath! + '/img.png'; // file_01.tmp is dump file, can be anything
  return new File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
//======================

// HERE IS WHERE THE CODE CRASHES (WHEN TRYING TO WRITE THE LOADED BYTES)
Future<File> writeToFile(ByteData data, String file) async {
  final buffer = data.buffer;
  Directory? tempDir = await getExternalStorageDirectory();
  String? tempPath = tempDir?.path;
  var filePath =
      tempPath! + '/' + file; // file_01.tmp is dump file, can be anything
  return new File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

extension Digitalsize on int {
  String get toDigital => this < 100000
      ? "${(.001 * this).roundToDouble()}" + "kB"
      : "${(.000001 * this).roundToDouble()}" + "MB";
}
