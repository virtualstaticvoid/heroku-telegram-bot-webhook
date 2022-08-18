library(telegram.bot)

# handler functions

start <- function(bot, update) {

  cat("Processing start", fill = TRUE)

  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = sprintf(
      "Welcome %s to the *Telegram Bot R Application* on _Heroku_!",
      update$message$from$first_name
    ),
    parse_mode = "Markdown"
  )

  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = "Send `/plot` or just a message.",
    parse_mode = "Markdown"
  )
}

plot <- function(bot, update) {

  cat("Processing plot", fill = TRUE)

  file <- tempfile("plot", fileext="png")
  png(file, units="px", bg="white", width=500, height=500)
  par(mar=c(2, 2, 4, 2))

  slices <- c(10, 12,4, 16, 8)
  lbls <- c("US", "UK", "Australia", "Germany", "France")

  pie(slices, labels=lbls, main="Pie Chart of Countries")

  dev.off()

  bot$sendPhoto(
    chat_id = update$message$chat_id,
    caption = "Example plot",
    photo = file
  )
}

echo <- function(bot, update){

  cat("Processing echo", fill = TRUE)

  bot$sendMessage(
    chat_id = update$message$chat_id,
    text = sprintf(
      "You sent this message:\n\n> %s",
      update$message$text
    ),
    parse_mode = "Markdown"
  )
}

# obtain token from environment variable
token <- Sys.getenv("TELEGRAM_TOKEN")
webhook_url <- Sys.getenv("WEBHOOK_URL")
port <- Sys.getenv("PORT")

# ensure trailing slash
if (!endsWith(webhook_url, "/")) {
  webhook_url <- paste0(webhook_url, "/")
}

# instantiate bot
bot <- Bot(token = token)

# create webhook
webhook <- Webhook(webhook_url = paste0(webhook_url, "webhook"), bot = bot, verbose = TRUE)

# wire up handlers
webhook <- webhook + CommandHandler("start", start)
webhook <- webhook + CommandHandler("plot", plot)
webhook <- webhook + MessageHandler(echo, MessageFilters$text)

# start webhook
webhook$start_server(
  host = "0.0.0.0",
  port = as.numeric(port)
)

# TODO: error handling and clean exit
