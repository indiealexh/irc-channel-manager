import 'package:irc/bot.dart';
import 'package:irc/client.dart';

import 'package:pledgemircbot/nickserve.dart';
import 'package:pledgemircbot/commands.dart';

main() {
  /*
   * Irc Connection configuration
   */
  IrcConfig config = new IrcConfig(
      host: "irc.freenode.net",
      port: 6667,
      nickname: "DartBot",
      username: "DartBot"
  );

  CommandBot bot = new CommandBot(config, prefix: "!"); //Define the command prefix e.g. !command
  NickServe ns;
  IrcCommands ic;

  bot.register((MOTDEvent event) {
    print("Connected");
    ns = new NickServe(bot);//Setup nickserv class instance
  });

  bot.register((ReadyEvent event) {
    ns.AuthSelf("BotPass");//Log bot into nickserv
    event.join("#channel");//Join irc channel
    ic = new IrcCommands(bot,ns);//Register commands
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
