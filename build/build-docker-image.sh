#!/usr/bin/env bash
mkdir buiding || true
cp funtool/funtool.4.0.0.26.disable.auto.update.exe buiding/injector-box/root/bin/
cp funtool/inject-dll buiding/injector-box/root/bin/
cp funtool/inject-monitor buiding/injector-box/root/bin/
cd buiding/injector-box
##api

sudo docker build -t danbai225/wechat-bot:latest .
#sudo docker push  danbai225/wechat-bot:latest

