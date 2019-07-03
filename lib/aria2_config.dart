import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'aria2_code.dart';
import 'aria2_event_bus.dart';
import 'aria2_message.dart';

class Aria2Config {
  final String version;
  final String aria2Path;
  final String aria2Config;
  final String secret;
  final String rpcUrl;
  final Map map = new Map();

  String aria2AppConfigPath;
  String aria2AppPath;

  Aria2Config(this.version, this.aria2Path, this.aria2Config, this.secret,
      this.rpcUrl);

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();

    if ((!await directory.exists()))
      await directory.create();
    this.aria2AppConfigPath = directory.path + "/aria2c.conf";
    this.aria2AppPath = directory.path + "/aria2c";


    File aria2AppConfigFile = new File(aria2AppConfigPath);

    if (!(await aria2AppConfigFile.exists())) {
      await aria2AppConfigFile.create();
      String context = await rootBundle.loadString(this.aria2Config);
      await aria2AppConfigFile.writeAsString(context);

      for (var row in new LineSplitter().convert(context)) {
        List<String> keyValue = row.split("=");
        map[keyValue[0]] = keyValue[1];
      }
    }

    File aria2AppBinFile = new File(aria2AppPath);

    if (!(await aria2AppBinFile.exists())) {
      print("aria2AppBinFile create");
      print(aria2AppPath);

      ByteData byteData = await rootBundle.load(this.aria2Path);

      aria2AppBinFile.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }

    // String _aria2AppPath = Path.combine(PathOperation.union, path1, path2)
  }

  saveConfigToFile() async {
    File file = new File(this.aria2AppConfigPath);
    if (!(await file.exists())) {
      Aria2EventBus.eventBus.fire(
          new Aria2Message(Aria2Code.ERROR, "not fond aria config", null));
    }
    StringBuffer sb = new StringBuffer();
    this.map.forEach((key, value) {
      sb.writeln(key + "=" + value);
    });
    await file.writeAsString(sb.toString());
  }
}
