library irc_commands;

import 'dart:io';
import 'dart:async';
import 'package:irc/bot.dart';
import 'package:irc/client.dart';

import 'package:pledgemircbot/nickserve.dart';

class IrcCommands {

  CommandBot bot;
  NickServe ns;

  IrcCommands(CommandBot mainBot, NickServe mainNs){
    bot = mainBot;
    ns = mainNs;
    _loadCommands();
  }

  void _loadCommands() {

    /*
     * !help - lists all available commands.
     */
    bot.command("help", (CommandEvent event) {
      event.reply("> ${Color.BLUE}Commands${Color.RESET}: ${bot.commandNames().join(', ')}");
    });

    /*
     * Lists the version of DartVM and the OS being run on.
     */
    bot.command("dart", (CommandEvent event) {
      event.reply("> Dart VM: ${Platform.version}");
    });

    /*
     * Hugs, because who doesn't like hugs?
     */
    bot.command("hug", (CommandEvent event) {
      String message = "hugs " + event.from;
      if (event.args.length > 0) {
        message = "can't find " + event.args[0];
        if (event.channel.allUsers.contains(event.args[0])) message = "hugs " + event.args[0];
      }
      event.channel.sendAction(message);
    });

    /*
     * Basic example command to relay information.
     */
    bot.command("dartbot", (CommandEvent event) {
      event.reply("> GitRepo: https://github.com/indiealexh/irc-channel-manager");
    });

    /*
     * Op an authorised user
     */
    bot.command("opme", (CommandEvent event){
      Future auth = ns.authUser(event);
      auth.then((value) {
        if (value){
          event.channel.op(event.from);
          event.reply("> Welcome back master!");
        } else {
          event.reply("> ${Color.RED}You are not Authorised${Color.RESET}");
          bot.client.kick(event.channel, event.from, "Not an authorised user");
        }
      });
    });

  }
}