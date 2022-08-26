# Example Telegram Bot R Application on Heroku

This is an example [Telegram][telegram] Bot application, which uses
the [`telegram.bot`][telegram.bot] R package and [heroku-buildpack-r][buildpack] on Heroku.

See [Marvin's Marvellous Guide to All Things Webhook][marvins] for information on Telegram Bots.

You can use this project as a template for your applications.

## Usage

[![Deploy][button]][deployapp]

Execute these commands to get started:

* Clone the Project

  ```bash
  git clone https://github.com/virtualstaticvoid/heroku-telegram-bot-app.git
  ```

* Create Heroku Application

  From the project's directory, create the heroku application.

  ```bash
  heroku create --stack heroku-22 --buildpack vsv/heroku-buildpack-r
  ```

* Configure Telegram Access Token

  Obtain a [telegram bot token][token] and provide it via the `TELEGRAM_TOKEN` environment variable.

  I.e. Replace the following value `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11` with your token.

  ```bash
  heroku config:set TELEGRAM_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
  ```

* Set Webhook URL
  
  Set the Webhook URL to that of the Heroku app.

  ```bash
  webhook_url=$(heroku apps:info -j | jq -r '.app.web_url')
  heroku config:set WEBHOOK_URL=$webhook_url
  ```

* Deploy Application

  ```bash
  git push heroku main
  ```

## Sending Messages

From your Telegram app, locate the Bot you created when obtaining the access token (above).

When you start the chat, the `/start` command will automatically be sent.

Any text message you send will be "echoed" back to you.

Finally, use the `/plot` command to receive an image containing a simple pie chart.

![](screenshot.png)

## Note

When deploying the application on Heroku's free tier, and the web dyno receives no traffic in 
a 30-minute period, [it will sleep][sleeping]. If a sleeping web dyno receives web traffic, 
it will become active again after a short delay (assuming your account has free dyno hours available).

_However_, when testing the application, which only receives `POST` requests from Telegram to 
deliver updates, the web dyno does *not* become active again automatically.

This won't be an issue if you are using _paid for_ dyno types such as [`hobby`][costs].

A work around for the issue is to make periodic `GET` requests or by running the `heroku scale` 
command, to force the web dyno to become active again.

```bash
heroku scale web=0
heroku scale web=1
```

## License

MIT License. Copyright (c) 2022 Chris Stefano. See [LICENSE](LICENSE) for details.

<!-- links -->

[buildpack]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[button]: https://www.herokucdn.com/deploy/button.svg
[costs]: https://devcenter.heroku.com/articles/usage-and-billing#cost
[deployapp]: https://heroku.com/deploy?template=https://github.com/virtualstaticvoid/heroku-telegram-bot-webhook/tree/main
[hobby]: https://devcenter.heroku.com/articles/dyno-types
[marvins]: https://core.telegram.org/bots/webhooks
[sleeping]: https://devcenter.heroku.com/articles/free-dyno-hours#dyno-sleeping
[telegram.bot]: https://cran.r-project.org/web/packages/telegram.bot/
[telegram]: https://telegram.org/
[token]: https://github.com/ebeneditos/telegram.bot#generating-an-access-token
