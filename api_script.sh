#!/bin/bash
GL_ADDR=#gitlab address
API_KEY=#add your api key
Number_Of_User=#insert number of users of gitlab
Number_Of_Pages=$(( $(( ($Number_Of_User/100) )) + 1 )) 

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

for i in $(seq 1 $Number_Of_Pages)
do
    declare -a USER_IDS=$(curl --header "PRIVATE-TOKEN: $API_KEY" "https://$GL_ADDR/api/v4/users?per_page=100&page=$i" | jq '.[].id')
    for user_id in $USER_IDS; do
	    curl --header "PRIVATE-TOKEN: $API_KEY" -X PUT -H "Content-Type: application/json" -d '{"projects_limit":0}' https://$GL_ADDR/api/v4/users/$user_id
	    echo $'\n'

    done
done

