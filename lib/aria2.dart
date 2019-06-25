library aria2;

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathUtils;
import 'dart:convert';
import 'aria2_code.dart';
import 'aria2_config.dart';
import 'aria2_event_bus.dart';
import 'aria2_json_rpc.dart';
import 'aria2_message.dart';

class Aria2 {
  final Aria2Config aria2config;
  Process _process;
  Aria2JsonRpc aria2jsonRpc;

  Aria2(this.aria2config);

  createAria2() async {
    Directory fileDir = await getApplicationDocumentsDirectory();
    File file = new File(pathUtils.join(fileDir.path, "aria2c"));
    bool isExists = await file.exists();
    if (!isExists) {
      await file.delete();
    }
    File aria2File =
        File.fromRawPath(Uint8List.fromList(aria2config.aria2Path.codeUnits));

    if (!(await aria2File.exists())) {
      Aria2EventBus.eventBus.fire(
          new Aria2Message(Aria2Code.ERROR, "not found Aria2 file", null));
      return;
    }

    await file.writeAsBytes(await aria2File.readAsBytes());

    await Process.run('chmod', ['777', aria2File.path]);
  }

  runAria2() {
    Process.run(aria2config.aria2Path,
        ["--conf-path=" + aria2config.aria2ConfigPath]).then((process) {
      process.stdout.transform(utf8.decoder).listen((data) {
        Aria2EventBus.eventBus
            .fire(new Aria2Message(Aria2Code.INFO, data, null));
      });
    });
  }

  stopAria2() {
    return Process.killPid(_process.pid);
  }

  restart() {
    if (stopAria2()) {
      runAria2();
    }
  }

  reConnectRpc() {
    if (aria2jsonRpc == null) aria2jsonRpc = new Aria2JsonRpc();
    aria2jsonRpc.reConnect(aria2config.rpcUrl, aria2config.secret);
  }

  closeRpc() async {
    if (aria2jsonRpc == null) aria2jsonRpc = new Aria2JsonRpc();
    await aria2jsonRpc.close();
  }


}
