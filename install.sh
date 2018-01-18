#! /bin/bash
set -eu -o pipefail

DIR_PREFIX=`dirname $0`
cd $DIR_PREFIX

mkdir teamcity

wget -P teamcity/binaries/ http://cdn.azul.com/zulu/bin/zulu7.21.0.3-jdk7.0.161-linux_x64.tar.gz
tar -zxf teamcity/binaries/zulu7.21.0.3-jdk7.0.161-linux_x64.tar.gz -C teamcity/
ln -s zulu7.21.0.3-jdk7.0.161-linux_x64 teamcity/java

wget -P teamcity/binaries/ https://download.jetbrains.com/teamcity/TeamCity-10.0.4.tar.gz
tar -zxf teamcity/binaries/TeamCity-10.0.4.tar.gz -C teamcity/

mv teamcity/TeamCity/buildAgent teamcity/TeamCity/buildAgent1
mkdir -p teamcity/TeamCity/buildAgent2
cp -R teamcity/TeamCity/buildAgent1/*  teamcity/TeamCity/buildAgent2/
sed -i.bak 's/name\=Default\ Agent/name\=Agent1/g' teamcity/TeamCity/buildAgent1/conf/buildAgent.properties
sed -i.bak 's/name\=Default\ Agent/name\=Agent2/g' teamcity/TeamCity/buildAgent2/conf/buildAgent.properties
sed -i.bak 's/ownPort\=9090/ownPort\=9091/g' teamcity/TeamCity/buildAgent2/conf/buildAgent.properties

cp tc.sh teamcity/
chmod 755 teamcity/tc.sh
