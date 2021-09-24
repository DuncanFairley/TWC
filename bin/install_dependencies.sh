#!/usr/bin/env bash

while read -ra dep; do
  DreamDownload "${dep[0]}"
done < ../include.txt
