library nickserve;

import 'dart:async';
import 'package:irc/bot.dart';
import 'package:irc/client.dart';

class NickServe {

  CommandBot bot;

  List authorisedUsers = ["indiealexh"];

  NickServe(CommandBot mainBot){
    bot = mainBot;
  }

  AuthSelf(String password) {
    bot.sendMessage("NickServ","identify " + password);
  }

  Future<bool> authUser(CommandEvent event){

    Completer completer = new Completer();

    bool output = false;
    bool authorised = false;
    if (authorisedUsers.contains(event.from)) authorised = true;
    event.client.whois(event.from)
    .then((info) {
      if(info.username == event.from && authorised == true) output=true;
      completer.complete(output);
    });

    return completer.future;
  }

}