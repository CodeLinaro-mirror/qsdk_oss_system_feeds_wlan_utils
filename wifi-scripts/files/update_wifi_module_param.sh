#!/bin/sh
#
# Copyright (c) 2021, The Linux Foundation. All rights reserved.

# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

format_module_param()
{
	touch /tmp/module_param_list
	touch /tmp/module_params_ini_format
	touch /tmp/module_params_ini

	# grep only module params from wireless file
	sed -ne '/qca-wifi/,$ p' /etc/config/wireless > /tmp/module_param_list

	# Remove empty lines in /tmp/module_param_list file
	sed -i '/^[[:space:]]*$/d' /tmp/module_param_list

	# Remove the first line ( config qca-wifi 'qcawifi' )
	sed -i 1d /tmp/module_param_list

	# moudule param format ( module_param=x )
	awk '{ $2=$2"="; s = ""; for (i = 2; i <= NF; i++) s = s$i " "; print s; }' /tmp/module_param_list > /tmp/module_params_ini_format

	# remove unnecessary characters [space], ['] and ["].
	sed "s/= /=/ g; s/'//g; s/\"//g" /tmp/module_params_ini_format > /tmp/module_params_ini

	# This file /ini/tmp_wifi_module_param.ini will be used during pre-init
	# to avoid file (file_name) overwrite due to consecutive reboot.
	cat /ini/wifi_module_param_backup.ini > /ini/wifi_module_param.ini
	cat /tmp/module_params_ini >> /ini/wifi_module_param.ini

	sync

	rm /tmp/module_param_list
	rm /tmp/module_params_ini_format
	rm /tmp/module_params_ini
}

do_load_wifi_module_param()
{
	local ker_ver=`uname -r |cut -d. -f1`

	if [ -f /etc/config/wireless ] && [ $ker_ver == 5 ]; then
		format_module_param
	fi
}
