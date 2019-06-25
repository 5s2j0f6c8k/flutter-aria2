import 'dart:io';

import 'aria2_code.dart';
import 'aria2_event_bus.dart';
import 'aria2_message.dart';

class Aria2Config {
  final String version;
  final String aria2Path;
  final String aria2ConfigPath;
  final String secret;
  final String rpcUrl;
  final Map map = new Map();

  Aria2Config(this.version, this.aria2Path, this.aria2ConfigPath, this.secret, this.rpcUrl) {
    readConfigToFile();
  }

  readConfigToFile() async {
    File file = new File(this.aria2ConfigPath);
    if (!(await file.exists())) {
      Aria2EventBus.eventBus.fire(
          new Aria2Message(Aria2Code.ERROR, "not fond aria config", null));
    }

    List<String> line = await file.readAsLines();
    for (var row in line) {
      List<String> keyValue = row.split("=");
      map[keyValue[0]] = keyValue[1];
    }
  }

  saveConfigToFile() async {
    File file = new File(this.aria2ConfigPath);
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
