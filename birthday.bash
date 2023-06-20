#author: Jonathan Macoco
#!/bin/bash
message="$1"
person="$2"
date="$3"
time="$4"
if [ $# -le 2 ]; 
then
	echo "Usage: message phone_number/icloud date time(optional)"
	exit 1
fi
ct=" "
IFS=":" read -r -a time_num <<< "$time"
if [ ${#time_num} -lt 1 ]; then
	hour=0
	min=0
else
	hour=${time_num[0]}
	min=${time_num[1]}
fi
IFS="/-" read -r -a date_num <<< "$date"
month=${date_num[0]}
day=${date_num[1]}
ct+="$min $hour $day $month "
ct+=" *"
ct=$(echo "${ct}" | tr -s ' ' | xargs)
imessage=" osascript -e 'tell application \"Messages\" to send \"${message}\" to buddy \"${person}\"'"
ct+="$imessage"
existing_crontab=$(crontab -l 2>/dev/null)
new_crontab="${existing_crontab}
${ct}
"
echo "$new_crontab" | crontab -

