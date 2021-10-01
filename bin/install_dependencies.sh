#!/usr/bin/env bash

while read -ra dep || [ -n "${dep[0]}" ]; do
  DreamDownload "${dep[0]}"
done < ../include.txt
