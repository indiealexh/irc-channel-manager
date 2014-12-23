// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:irc/bot.dart';
import 'package:irc/client.dart';

import 'package:pledgemircbot/nickserve.dart';
import 'package:pledgemircbot/commands.dart';

main() {
  IrcConfig config = new IrcConfig(
      host: "irc.freenode.net",
      port: 6667,
      nickname: "DartBot",
      username: "DartBot"
  );

  CommandBot bot = new CommandBot(config, prefix: "!");
  NickServe ns;
  IrcCommands ic;

  bot.register((MOTDEvent event) {
    print("Connected");
    ns = new NickServe(bot);
  });

  bot.register((ReadyEvent event) {
    ns.AuthSelf("BotPass");
    event.join("#channel");
    ic = new IrcCommands(bot,ns);
  });

  bot.register((BotJoinEvent event) {
    print("Joined ${event.channel.name}");
  });

  bot.register((BotPartEvent event) {
    print("Left ${event.channel.name}");
  });

  bot.register((MessageEvent event) => print("<${event.target}><${event.from}> ${event.message}"));

  bot.connect();

}
