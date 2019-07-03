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
  Aria2JsonRpc aria2jsonRpc;

  Aria2(this.aria2config);

  createAria2() async {
    await aria2config.init();
    ProcessResult processResult = await Process.run(
        "chmod", ["777", this.aria2config.aria2AppPath]);
    print(processResult.stdout);
    await runAria2();
  }

  runAria2() {
    print(aria2config.aria2AppPath);
    Process.run(aria2config.aria2AppPath,
        ["--conf-path=" + aria2config.aria2AppConfigPath]);
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
