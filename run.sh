#!/bin/bash
tmpfile=$(mktemp)
tmpfile2=$(mktemp)
wget https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt -O -| base64 -d  >$tmpfile
cat custom.list >> $tmpfile
./autoproxy2domain $tmpfile > $tmpfile2

while read line ;do
		if [ `echo $line |grep '^www\.' |wc -l ` -eq 1 ] ;then
				echo "server=/$line/127.0.0.1#1053"
		else
				echo "server=/.$line/127.0.0.1#1053"
		fi
done < $tmpfile2 > m.txt
rm $tmpfile
rm $tmpfile2
sudo mv m.txt /etc/dnsmasq.d/gfw.conf
echo 'done';
