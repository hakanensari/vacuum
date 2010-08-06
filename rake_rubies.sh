#!/bin/bash

# http://github.com/papercavalier/rake_rubies

if which rvm > /dev/null; then
  RUBIES=$(echo `rvm list strings` | tr " " "\n")
  if [ -e ".rvmrc" ]; then
    GEMSET=`grep -m 1 -o -e "\@[^ ]*" .rvmrc`
  fi
  for RUBY in $RUBIES; do
    if [ $RUBY != "default" ]; then
      if [ -e "Gemfile" ]; then
        if !(which bundle > /dev/null); then
          gem install bundler --pre
        fi
        rvm "$RUBY$GEMSET" ruby -S bundle install > /dev/null
      fi
      rvm "$RUBY$GEMSET" rake $1
    fi
  done
  if [ -e ".rvmrc" ]; then
    sh .rvmrc > /dev/null
  fi
else
  rake $1
fi
