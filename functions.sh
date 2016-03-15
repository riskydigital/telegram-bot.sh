URL='https://api.telegram.org/bot'$TOKEN
JSON="./JSON.sh"

TIME=10
TEXEC="wget -qO- -T $TIME"

function telegram_exec
{
  $TEXEC --post-data="$2" $URL/$1
}

function send_message
{
  #echo "SEND $1 \"$2\""
  telegram_exec "sendMessage" "chat_id=$1&text=$2"
}

function get_message
{
  res=`telegram_exec "getUpdates?offset=$1&limit=1"`
}

function get_name
{
  res=`telegram_exec getMe`
  res=$(echo $res | $JSON -s | egrep '\["result","username"\]' \
      | cut -f 2 | cut -d '"' -f 2)
}

function send_markdown_message
{
  telegram_exec "$URL/sendMessage" "chat_id=$1&text=$2&parse_mode=markdown"
}

function send_doc
{
  telegram_exec "sendDocument" "chat_id=$1&document=@$2"
}

function send_photo
{
  telegram_exec "sendPhoto" "chat_id=$1&photo=@$2"
}
