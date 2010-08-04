#!/bin/bash
RUBIES=$(echo `rvm list strings` | tr " " "\n")

for RUBY in $RUBIES; do
  if [ $RUBY != "default" ]; then
    rvm "$RUBY@global" ruby -S bundle install
    rvm "$RUBY@global" rake $1
  fi
done
