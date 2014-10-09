#!/bin/bash

modules_dir="/etc/puppet/modules"
next_page_link="https://api.github.com/orgs/cnaf/repos"

while [ ! -z $next_page_link ]
do

  echo $next_page_link

  list=$(curl $next_page_link|grep html_url|sed  's/[",]//g'|sed -rn  's/.+(https.+(puppet))/\1/p'|sed  's/https/git/g')

  for url in $list; do
    repo=$(echo $url|sed -rn  's/(^git.+(puppet))/\2/p')
    git clone $url $modules_dir/$repo;
  done
  
  next_page_link=$(curl -I $next_page_link |sed -nr 's/(.*Link: <(.+)>; rel="next".+)/\2/p')

done

