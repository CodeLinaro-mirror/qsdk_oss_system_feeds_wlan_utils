#!/bin/sh
#
# Copyright (c) 2020, The Linux Foundation. All rights reserved.

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

#Usage: update_ini_file <file_name> <ini_param> <value>
function update_ini_file()
{
	local filename=$1
	local param=$2
	local value=$3
	update_ini_cmd="grep -q $param /ini/$filename && sed -i '/$param=/c $param=$value' /ini/$filename || echo $param=$value >> /ini/$filename"
	eval $update_ini_cmd
	sync
}

#Usage: update_ini_internal_file <file_name> <ini_param> <value>
function update_ini_internal_file()
{
	local filename=$1
	local param=$2
	local value=$3
	update_ini_internal_cmd="grep -q $param /ini/internal/$filename && sed -i '/$param=/c $param=$value' /ini/internal/$filename || echo $param=$value >> /ini/internal/$filename"
	eval $update_ini_internal_cmd
	sync
}

function do_init_kernel54_config()
{
	echo -n "/ini" > /sys/module/firmware_class/parameters/path
	update_ini_file global.ini cfg80211_config "1"

	[ -f /tmp/sysinfo/board_name ] && {
		board_name=ap$(cat /tmp/sysinfo/board_name | awk -F 'ap' '{print$2}')
	}

	if [ "$board_name" = "ap-hk10-c1"  ]; then
		update_ini_internal_file global_i.ini mode_2g_phyb "1"
	fi
}
