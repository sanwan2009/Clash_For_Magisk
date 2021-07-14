SKIPUNZIP=1

clash_data_dir="/data/clash"
modules_dir="/data/adb/modules"
CPFM_mode_dir="${modules_dir}/clash_premium"
mod_config="${clash_data_dir}/clash.config"

if [ -d "${CPFM_mode_dir}" ] ; then
    touch ${CPFM_mode_dir}/remove && ui_print "- CPFM模块在重启后将会被删除."
fi


unzip -o "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH >&2
mkdir -p ${clash_data_dir}

if [ "$(md5sum ${MODPATH}/clash.config | awk '{print $1}')" != "$(md5sum ${mod_config} | awk '{print $1}')" ] ; then
    if [ -f "${mod_config}" ] ; then
        mv -f ${mod_config} ${clash_data_dir}/config.backup
        ui_print "- 配置文件有变化，原配置文件已备份为config.backup."
        ui_print "- 建议查看配置文件无误后再重启手机."
    fi
    mv ${MODPATH}/clash.config ${clash_data_dir}/
else
    rm -f ${MODPATH}/clash.config
fi

if [ ! -f "${clash_data_dir}/template" ] ; then
    mv ${MODPATH}/template ${clash_data_dir}/
else
    rm -f ${MODPATH}/template
fi

if [ ! -f "${clash_data_dir}/packages.list" ] ; then
    touch ${clash_data_dir}/packages.list
fi

sleep 1

ui_print "- 开始设置环境权限."
set_perm_recursive ${MODPATH} 0 0 0755 0644
set_perm_recursive ${MODPATH}/system/bin 0 0 0755 0755
set_perm_recursive ${MODPATH}/scripts 0 0 0755 0755
set_perm_recursive ${clash_data_dir} 0 0 0755 0644
