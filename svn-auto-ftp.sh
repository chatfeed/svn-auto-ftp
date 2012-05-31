#!/usr/bin/env bash 
#
# @desc 将两个版本里发变了的文件发送到测试服
# @author chatfeed@gmail.com
#
#config start
svn_repos='http://192.168.1.201/server/'
#path to save diffrent files
tmp_path='/tmp/diffversion/'
#use sftp 
host='192.168.1.123'
user='root'
pass='123456'
# remote server path
spath=''
#config end
if [ abc"$2" == 'abc' ];then
	newversion=`svn log $svn_repos -l 2| awk '{if(NR==2){print $1}}'`
	oldversion=`svn log $svn_repos -l 2| awk '{if(NR==6){print $1}}'`
	newversion=`echo ${newversion##*r}`
	oldversion=`echo ${oldversion##*r}`
else
	newversion=`echo $1`
	oldversion=`echo $2`
fi
mkdir -p $tmp_path
for i in `svn diff --old=$svn_repos@$oldversion --new=$svn_repos@$newversion --summarize | awk '{if($1!="D"){print $2}}'`;do
	relate_path=${i:${#svn_repos}:(${#i}-${#svn_repost})} 
	fname=${i##*/}
	fpath=${relate_path%/*}
	echo $tmp_path$fname
	mkdir -p $tmp_path$fpath
	svn export $i $tmp_path$relate_path
	#if [ -f $tmp_path$fname ];then
	#	echo $fname
	#fi
	#scp  $tmp_path$fname  $scp_path$relate_path
	#rm -rf $scp_path$relate_path
done
lftp -c "open -u $user,$pass sftp://$host; mirror -R --only-newer ${tmp_path%/} ${spath%/}"
rm -rf $tmp_path


