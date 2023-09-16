#!/bin/bash

#  user id. Can be obtained using @GetMyIdBot
TELEGRAM_USER_ID=71115111
#  user id. Is obtained when creating bot via @BotFather
TELEGRAM_BOT_TOKEN=6627077999:AAEaRjYRMsF27MhpIv8Jdwb9b8hXDd3vVKc

if [ "$CI_JOB_STATUS" = success ] && ! [ "$CI_JOB_STAGE" = deploy ]; then
  exit 0;
fi


URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
CI_COMMIT_AUTHOR=${CI_COMMIT_AUTHOR//[<>]/}
CI_JOB_STATUS=${CI_JOB_STATUS^^}

TEXT="
Project:+$CI_PROJECT_NAME%0A\
$CI_JOB_STAGE:$CI_JOB_NAME status: <b>$CI_JOB_STATUS</b>%0A\
URL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/%0A\
Branch:+$CI_COMMIT_REF_SLUG%0A\
Commit author:+$CI_COMMIT_AUTHOR%0A\
Commit message:%0A\
$CI_COMMIT_MESSAGE"

TIME=3
curl -s \
     --max-time $TIME \
     --data parse_mode=HTML \
     --data chat_id=$TELEGRAM_USER_ID \
     --data text="$TEXT" \
     --data disable_web_page_preview=1 \
     --request POST $URL \
     > /dev/null
