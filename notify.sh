#!/bin/bash

#  user id. Can be obtained using @GetMyIdBot
TELEGRAM_USER_ID=71115111
#  user id. Is obtained when creating bot via @BotFather
TELEGRAM_BOT_TOKEN=6627077999:AAEaRjYRMsF27MhpIv8Jdwb9b8hXDd3vVKc

URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
TEXT="
Deploy status: $1%0A%0A\
Project:+$CI_PROJECT_NAME%0A\
URL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/%0A\
Branch:+$CI_COMMIT_REF_SLUG"

TIME=10
curl -s --max-time $TIME \
     -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT" \
     $URL > /dev/null
