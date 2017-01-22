#!/bin/bash
# do not edit this file!!!
# author: yuan.wu


#------------------------------------------------------
# 全局变量定义
#------------------------------------------------------
# 1: run each command and print, anything else just print command
RUN=1

# 网站根目录
ROOT_PATH=/cygdrive/e/www/
# SVN 准备目录
SVN_PATH=/cygdrive/e/update_svn/jyl/
# 备份文件目录
BACKUP_PATH=/cygdrive/e/www_backup/
# 临时目录
TMP_PATH=/cygdrive/e/tmp/
# 家易乐备份文件名
JYL_BACK_NAME=jylbak
# 家易乐临时备份路径 /cygwin/e/tmp/jylbak/
TMP_JYLBAK_PATH=${TMP_PATH}${JYL_BACK_NAME}/

# app
APP_DIR=app/
APP_ROOT_PATH=${ROOT_PATH}${APP_DIR} # /cygdrive/e/www/app/
APP_BACK_PATH=${TMP_JYLBAK_PATH}${APP_DIR} # /cygdrive/e/tmp/jylbak/app/
APP_SVN_PATH=${SVN_PATH}${APP_DIR} # /cygdrive/e/update_svn/jyl/app/
APP_UPDATE_LIST=(Common Conf Lib ThinkPHP Tpl webserviceclass)
# root update dir list
ROOT_UPDATE_LIST=(account_pay img system inc javascript js css webservice)
# ytj
YTJ_DIR=ytj/
YTJ_ROOT_PATH=${ROOT_PATH}${YTJ_DIR} # /cygdrive/e/www/ytj/
YTJ_BACK_PATH=${TMP_JYLBAK_PATH}${YTJ_DIR} # /cygdrive/e/tmp/jylbak/ytj/
YTJ_SVN_PATH=${SVN_PATH}${YTJ_DIR} # /cygdrive/e/update_svn/jyl/ytj/
YTJ_UPDATE_LIST=(account_pay ad alisaoma flash img inc javascript mp3 style webserviceclass)
# pc
PC_DIR=ytj/pc/
PC_ROOT_PATH=${ROOT_PATH}${PC_DIR} # /cygdrive/e/www/ytj/pc/
PC_BACK_PATH=${TMP_JYLBAK_PATH}${PC_DIR} # /cygdrive/e/tmp/jylbak/ytj/pc/
PC_SVN_PATH=${SVN_PATH}${PC_DIR} # /cygdrive/e/update_svn/jyl/ytj/pc/
PC_UPDATE_LIST=(ezf inc javascript img style webserviceclass)
# phone
PHONE_DIR=ytj/phone/
PHONE_ROOT_PATH=${ROOT_PATH}${PHONE_DIR} # /cygdrive/e/www/ytj/phone/
PHONE_BACK_PATH=${TMP_JYLBAK_PATH}${PHONE_DIR} # /cygdrive/e/tmp/jylbak/ytj/phone/
PHONE_SVN_PATH=${SVN_PATH}${PHONE_DIR} # /cygdrive/e/update_svn/jyl/ytj/phone/
PHONE_UPDATE_LIST=(account_pay ezf img javascript Public qiche wzf)
# wap
WAP_DIR=ytj/wap/
WAP_ROOT_PATH=${ROOT_PATH}${WAP_DIR} # /cygdrive/e/www/ytj/wap/
WAP_BACK_PATH=${TMP_JYLBAK_PATH}${WAP_DIR} # /cygdrive/e/tmp/jylbak/ytj/wap/
WAP_SVN_PATH=${SVN_PATH}${WAP_DIR} # /cygdrive/e/update_svn/jyl/ytj/wap/
WAP_UPDATE_LIST=(account_pay ezf img javascript Public qiche wzf)


# 输出并执行
function exec_cmd() {
	echo "$1"
	if [ $RUN -eq 1 ];then
		$1
	fi
}


# 删除目录
function check_and_del_dir() {
	if [ "-$1"  == '-' ];then
		echo 'false'
	else
		if [ -d $1 ];then
			exec_cmd "rm -rf $1"
			if [ $? == 0 ];then
				echo "true"
			else
				echo "false"
			fi
		else
			echo "true"
		fi
	fi
}

function init() {
	# 清理临时目录
	exec_cmd "rm -rf ${TMP_JYLBAK_PATH}*"

	if [ -d ${BACKUP_PATH} ];then
		:
	else
		make_dir ${BACKUP_PATH}
	fi

	# svn 更新
	# pwd: /cygdrive/e/update_svn/jyl/
	exec_cmd "cd ${SVN_PATH}"
	if [ $? -eq 0 ];then
	    exec_cmd "svn update"
	else
		echo '退出：更新SVN停止'
		exit
	fi
}


function make_dir() {
	if [ -d $1 ];then
		:
	else
		exec_cmd "mkdir -p $1"
	fi
}


#------------------------------------------------------
# 备份 app 目录
#------------------------------------------------------
function backup_app() {
	# pwd: /cygdrive/e/www/app/
	exec_cmd "cd ${APP_ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/app/
	make_dir ${APP_BACK_PATH}
	# 拷贝 app下的所有文件 到 /cygdrive/e/tmp/jtlbak/app/ 
	 exec_cmd "find -maxdepth 1 -type f -exec cp -t ${APP_BACK_PATH} {} +"
	# 拷贝app下指定目录 到 /cygdrive/e/tmp/jtlbak/app/
	for (( i = 0; i < ${#APP_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${APP_ROOT_PATH}${APP_UPDATE_LIST[i]} ${APP_BACK_PATH}"
	done
}


#------------------------------------------------------
# 备份 ytj 目录
#------------------------------------------------------
function backup_ytj() {
	# pwd: /cygdrive/e/www/
	exec_cmd "cd ${ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/
	make_dir ${TMP_JYLBAK_PATH}
	# 拷贝 www根目录 下的所有文件 到 /cygdrive/e/tmp/jtlbak/
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${TMP_JYLBAK_PATH} {} +"
	# 拷贝www下指定目录 到 /cygdrive/e/tmp/jtlbak/
	for (( i = 0; i < ${#ROOT_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${ROOT_PATH}${ROOT_UPDATE_LIST[i]} ${TMP_JYLBAK_PATH}"
	done
	echo

	# 1.备份 ytj
	# pwd: /cygdrive/e/www/ytj/
	exec_cmd "cd ${YTJ_ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/ytj/
	make_dir ${YTJ_BACK_PATH}
	# 拷贝 ytj下的所有文件 到 /cygdrive/e/tmp/jtlbak/ytj/ 
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${YTJ_BACK_PATH} {} +"
	# 拷贝 ytj下指定目录 到 /cygdrive/e/tmp/jtlbak/ytj/
	for (( i = 0; i < ${#YTJ_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${YTJ_ROOT_PATH}${YTJ_UPDATE_LIST[i]} ${YTJ_BACK_PATH}"
	done
	echo

	# 2.备份 pc
	# pwd: /cygdrive/e/www/ytj/pc/
	exec_cmd "cd ${PC_ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/ytj/pc/
	make_dir ${PC_BACK_PATH}
	# 拷贝 pc 下的所有文件 到 /cygdrive/e/tmp/jtlbak/ytj/pc/
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${PC_BACK_PATH} {} +"
	# 拷贝 pc 下指定目录 到 /cygdrive/e/tmp/jtlbak/ytj/pc/
	for (( i = 0; i < ${#PC_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${PC_ROOT_PATH}${PC_UPDATE_LIST[i]} ${PC_BACK_PATH}"
	done
	echo

	# 3.备份 phone
	# pwd: /cygdrive/e/www/ytj/phone/
	exec_cmd "cd ${PHONE_ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/ytj/phone/
	make_dir ${PHONE_BACK_PATH}
	# 拷贝 phone 下的所有文件 到 /cygdrive/e/tmp/jtlbak/ytj/phone/
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${PHONE_BACK_PATH} {} +"
	# 拷贝 phone 下指定目录 到 /cygdrive/e/tmp/jtlbak/ytj/phone/
	for (( i = 0; i < ${#PHONE_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${PHONE_ROOT_PATH}${PHONE_UPDATE_LIST[i]} ${PHONE_BACK_PATH}"
	done
	echo

	# 4.备份 wap
	# pwd: /cygdrive/e/www/ytj/wap/
	exec_cmd "cd ${WAP_ROOT_PATH}"
	# 创建 /cygdrive/e/tmp/jtlbak/ytj/wap/
	make_dir ${WAP_BACK_PATH}
	# 拷贝 wap 下的所有文件 到 /cygdrive/e/tmp/jtlbak/ytj/wap/
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${WAP_BACK_PATH} {} +"
	# 拷贝 wap 下指定目录 到 /cygdrive/e/tmp/jtlbak/ytj/wap/
	for (( i = 0; i < ${#WAP_UPDATE_LIST[@]}; ++i ));
	do
		exec_cmd "cp -R ${WAP_ROOT_PATH}${PHONE_UPDATE_LIST[i]} ${WAP_BACK_PATH}"
	done
}


# 压缩备份
function do_backup() {
	# pwd: /cygdrive/e/tmp/
	exec_cmd "cd ${TMP_PATH}"
	z_name=$(date -d "today" +"%Y%m%d_%H%M%S").7z
	# 压缩拷贝 /cygdrive/e/tmp/jylbak/ 到 /cygdrive/e/www_backup
	exec_cmd "7z a ${z_name} ${JYL_BACK_NAME}"
	# 移动备份文件到 /cygdrive/e/www_backup
	exec_cmd "mv ${z_name} $BACKUP_PATH"
	# 删除临时文件
	exec_cmd "rm -rf ${TMP_JYLBAK_PATH}"
}



#------------------------------------------------------
# 发布
#------------------------------------------------------
# 发布 app 目录
#------------------------------------------------------
function update_app() {
	# 拷贝 app 下文件以及指定目录
	# pwd: /cygdrive/e/update_svn/jyl/app/
	exec_cmd "cd ${APP_SVN_PATH}"
	# 拷贝 app 下的所有文件 到 /cygdrive/e/www/app/ 
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${APP_ROOT_PATH} {} +"
	# 拷贝app下指定目录 到 /cygdrive/e/tmp/jtlbak/app/
	for (( i = 0; i < ${#APP_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${APP_UPDATE_LIST[i]} ${APP_ROOT_PATH}"
		exec_cmd "cp -R ${APP_UPDATE_LIST[i]} ${APP_ROOT_PATH}"
	done
}


#------------------------------------------------------
# 发布 ytj 目录
#------------------------------------------------------
function update_ytj() {
	# 更新 www 目录下文件
	# pwd: /cygdrive/e/update_svn/jyl/
	exec_cmd "cd ${SVN_PATH}"
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${ROOT_PATH} {} +"
	# 更新 www 下指定目录
	for (( i = 0; i < ${#ROOT_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${ROOT_UPDATE_LIST[i]} ${ROOT_PATH}"
		exec_cmd "cp -R ${ROOT_UPDATE_LIST[i]} ${ROOT_PATH}"
	done
	echo

	# 更新 ytj 目录
	# pwd: /cygdrive/e/update_svn/jyl/ytj/
	exec_cmd "cd ${YTJ_SVN_PATH}"
	# 更新 ytj 下的文件
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${YTJ_ROOT_PATH} {} +"
	# 更新 ytj 下指定目录
	for (( i = 0; i < ${#YTJ_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${YTJ_UPDATE_LIST[i]} ${YTJ_ROOT_PATH}"
		exec_cmd "cp -R ${YTJ_UPDATE_LIST[i]} ${YTJ_ROOT_PATH}"
	done
	echo

	# 更新 pc 目录
	# pwd: /cygdrive/e/update_svn/jyl/ytj/pc/
	exec_cmd "cd ${PC_SVN_PATH}"
	# 更新 pc 下的文件
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${PC_ROOT_PATH} {} +"
	# 更新 pc 下指定目录
	for (( i = 0; i < ${#PC_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${PC_UPDATE_LIST[i]} ${PC_ROOT_PATH}"
		exec_cmd "cp -R ${PC_UPDATE_LIST[i]} ${PC_ROOT_PATH}"
	done
	echo

	# 更新 phone 目录
	# pwd: /cygdrive/e/update_svn/jyl/ytj/phone/
	exec_cmd "cd ${PHONE_SVN_PATH}"
	# 更新 phone 下的文件
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${PHONE_ROOT_PATH} {} +"
	# 更新 phone 下指定目录
	for (( i = 0; i < ${#PHONE_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${PHONE_UPDATE_LIST[i]} ${PHONE_ROOT_PATH}"
		exec_cmd "cp -R ${PHONE_UPDATE_LIST[i]} ${PHONE_ROOT_PATH}"
	done
	echo

	# 更新 wap 目录
	# pwd: /cygdrive/e/update_svn/jyl/ytj/wap/
	exec_cmd "cd ${WAP_SVN_PATH}"
	# 更新 wap 下的文件
	exec_cmd "find -maxdepth 1 -type f -exec cp -t ${WAP_ROOT_PATH} {} +"
	# 更新 wap 下指定目录
	for (( i = 0; i < ${#WAP_UPDATE_LIST[@]}; ++i ));
	do
		#exec_cmd "rsync -av ${PHONE_UPDATE_LIST[i]} ${PHONE_ROOT_PATH}"
		exec_cmd "cp -R ${WAP_UPDATE_LIST[i]} ${WAP_ROOT_PATH}"
	done
}


# 修改配置文件
function update_config() {
	# 修改 app 配置文件
	exec_cmd "cp ${APP_ROOT_PATH}Conf/config.production.php ${APP_ROOT_PATH}Conf/config.php"
	# 修改 system 配置文件
	exec_cmd "cp ${ROOT_PATH}system/class/config.production.php ${ROOT_PATH}system/class/config.php"
}


function deploy_all() {
	echo
	echo '--------开始备份--------'
	echo

	echo '备份www...'
	backup_ytj
	echo '备份www...结束'

	echo

	echo '备份app...'
	backup_app
	echo '备份app...结束'

	echo

	# 压缩备份
	echo '压缩..'
	do_backup
	echo '压缩...结束'

	echo
	echo '--------开始上传代码--------'
	echo

	# 更新

	echo '更新ytj...'
	update_ytj
	echo '更新ytj...结束'

	echo

	echo '更新app...'
	update_app
	echo '更新app...结束'

	echo
}


function rollback() {
	# 删除临时文件
	rst=$( check_and_del_dir "${TMP_JYLBAK_PATH}" )
	if [ "$rst" == 'false' ];then
		echo "删除目录 ${TMP_JYLBAK_PATH} 失败"
		exit
	fi

	# /cygdrive/e/www_backup/
	exec_cmd "cd ${BACKUP_PATH}"

	if [ "-$1" == '-' ];then
		# 回滚最近更新
		exec_cmd "7z x `ls -t ${BACKUP_PATH} | head -1` -o${TMP_PATH}"
		if [ "$?" == 0 ];then
			exec_cmd "cp -R ${TMP_JYLBAK_PATH}* ${ROOT_PATH}"
		else
			echo '解压失败'
		fi
	else
		# 回滚指定归档文件
		if [ -d "$1" ];then
			exec_cmd "7z x $1 ${TMP_PATH}"
			if [ "$?" == 0 ];then
				exec_cmd "cp -R ${TMP_JYLBAK_PATH}* ${ROOT_PATH}"
			else
				echo '解压失败'
			fi
		else
			echo "归档文件不存在: $1"
			exit
		fi
	fi

	# 删除临时文件
	exec_cmd "rm -rf ${TMP_JYLBAK_PATH}"

	echo 'done'
}


function deploy_part() {
	if [ "$1" == 'app' ];then
		echo
		echo '--------开始备份--------'
		echo
		# deploy app
		echo '备份app...'
		backup_app
		echo '备份app...结束'

		echo

		# 压缩备份
		echo '压缩..'
		do_backup
		echo '压缩...结束'

		echo

		echo
		echo '--------开始上传代码--------'
		echo
		# 更新
		echo '更新...'
		update_app
		echo '更新...结束'
	elif [ "$1" == 'ytj' ];then
		echo
		echo '--------开始备份--------'
		echo
		# deploy ytj
		echo '备份www...'
		backup_ytj
		echo '备份www...结束'

		echo

		# 压缩备份
		echo '压缩...'
		do_backup
		echo '压缩...结束'

		echo

		echo
		echo '--------开始上传代码--------'
		echo
		# 更新
		echo '更新ytj...'
		update_ytj
		echo '更新ytj...结束'

		echo

	else
		#deploy all
		deploy_all
	fi

	echo
	echo '--------开始修改配置文件--------'
	echo

	update_config

	echo
	echo 'done'
}


function echo_help() {
	echo 'Usage: -[deploy/debug/rollback/rollback_debug] [app/ytj]

	-deploy: 执行发布 发布内容根据第二个参数确定
		app: 只发布app
		ytj: 只发布网站目录

	-debug: 发布所有，只打印不执行实际脚本
		app: 只发布app
		ytj: 只发布网站目录

	-rollback: 回滚发布操作 第二个参数用来指定回滚的归档文件名称
               第二个参数不指定直接回滚最近一次归档

	-rollback_debug: debug回滚发布操作 第二个参数用来指定回滚的归档文件名称只打印不执行
               第二个参数不指定直接回滚最近一次归档

示例:
发布 app
$./deploy.sh -deploy app

回滚测试指定文件 rollback_debug
$./deploy.sh -rollback_debug 1231231213.7z
 '
}


# main  入口
if [ "$1" == '-deploy' ];then
	init
	deploy_part $2
elif [ "$1" == '-debug' ];then
	RUN=0
	deploy_part $2
elif [ "$1" == '-rollback' ];then
	rollback $2
elif [ "$1" == '-rollback_debug' ];then
	RUN=0
	rollback $2
elif [ "$1" == '-H' ];then
	echo_help
elif [ "$1" == '-h' ];then
	echo_help
elif [ "$1" == '--help' ];then
	echo_help
else
    echo_help
fi