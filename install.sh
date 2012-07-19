#!/bin/bash

echo "please run\nrvm --rvmrc --create 1.9.3@kiwi-ironfan\nmanually in an interactive shell"

gem install bundler
bundle install
thor kiwi:setup