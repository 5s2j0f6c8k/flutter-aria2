import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:json_rpc_2/json_rpc_2.dart';
import "package:web_socket_channel/html.dart";

import 'aria2_code.dart';
import 'aria2_event_bus.dart';
import 'aria2_message.dart';

class Aria2JsonRpc {
  HtmlWebSocketChannel _socket;
  Client _client;

  reConnect(String url, String secret) async {
    if (_client != null) {
      await _client.close();
      await _socket.sink.close();
    }
    _socket = HtmlWebSocketChannel.connect('ws://localhost:4321');
    _client = new json_rpc.Client(_socket.cast<String>());
    _client.listen().catchError((error) {
      Aria2EventBus.eventBus
          .fire(new Aria2Message(Aria2Code.ERROR, error.toString(), null));
    });
  }

  close() async {
    if (_client != null) {
      await _client.close();
      await _socket.sink.close();
    }
  }

  addUri(List<String> url) async {
    return await _client.sendRequest("aria2.addUri", [url]);
  }

  addTorrent(String base64Torrent) async {
    return await _client.sendRequest("aria2.addTorrent", [base64Torrent]);
  }

  addMetalink(String base64Metalink) async {
    return await _client.sendRequest("aria2.addMetalink", [base64Metalink]);
  }

  remove(String gid) async {
    return await _client.sendRequest("aria2.remove", [gid]);
  }

  forceRemove(String gid) async {
    return await _client.sendRequest("aria2.forceRemove", [gid]);
  }

  pause(String gid) async {
    return await _client.sendRequest("aria2.pause", [gid]);
  }

  pauseAll() async {
    return await _client.sendRequest("aria2.pauseAll");
  }

  forcePause() async {
    return await _client.sendRequest("aria2.forcePause");
  }

  forcePauseAll() async {
    return await _client.sendRequest("aria2.forcePauseAll");
  }

  unPause() async {
    return await _client.sendRequest("aria2.unpause");
  }

  unPauseAll() async {
    return await _client.sendRequest("aria2.unpauseAll");
  }

  tellStatus(String gid) async {
    return await _client.sendRequest("aria2.tellStatus", [gid]);
  }

  getUris(String gid) async {
    return await _client.sendRequest("aria2.getUris", [gid]);
  }

  getFiles(String gid) async {
    return await _client.sendRequest("aria2.getFiles", [gid]);
  }

  getPeers(String gid) async {
    return await _client.sendRequest("aria2.getPeers", [gid]);
  }

  getServers(String gid) async {
    return await _client.sendRequest("aria2.getServers", [gid]);
  }

  tellActive() async {
    return await _client.sendRequest("aria2.tellActive");
  }

  tellWaiting(int offset, int num) async {
    return await _client.sendRequest("aria2.tellWaiting", [offset, num]);
  }

  tellStopped(int offset, int num) async {
    return await _client.sendRequest("aria2.tellStopped", [offset, num]);
  }

  changePosition(String gid, int pos, String how) async {
    return await _client.sendRequest("aria2.changePosition", [gid, pos, how]);
  }

  changeUri(String gid, int fileIndex, List<String> delUris,
      List<String> addUris) async {
    return await _client
        .sendRequest("aria2.changeUri", [gid, fileIndex, delUris, addUris]);
  }

  getOption(String gid) async {
    return await _client.sendRequest("aria2.getOption", [gid]);
  }

  changeOption(String gid, option) async {
    return await _client.sendRequest("aria2.changeOption", [gid, option]);
  }

  getGlobalOption() async {
    return await _client.sendRequest("aria2.getGlobalOption");
  }

  changeGlobalOption(option) async {
    return await _client.sendRequest("aria2.changeGlobalOption", [option]);
  }

  getGlobalStat() async {
    return await _client.sendRequest("aria2.getGlobalStat");
  }

  purgeDownloadResult() async {
    return await _client.sendRequest("aria2.purgeDownloadResult");
  }

  removeDownloadResult(String gid) async {
    return await _client.sendRequest("aria2.removeDownloadResult", [gid]);
  }

  getVersion() async {
    return await _client.sendRequest("aria2.getVersion");
  }

  getSessionInfo() async {
    return await _client.sendRequest("aria2.getSessionInfo");
  }

  shutdown() async {
    return await _client.sendRequest("aria2.shutdown");
  }

  forceShutdown() async {
    return await _client.sendRequest("aria2.forceShutdown");
  }

  saveSession() async {
    return await _client.sendRequest("aria2.saveSession");
  }

  listMethods() async {
    return await _client.sendRequest("aria2.listMethods");
  }

  listNotifications() async {
    return await _client.sendRequest("aria2.listNotifications");
  }
}
