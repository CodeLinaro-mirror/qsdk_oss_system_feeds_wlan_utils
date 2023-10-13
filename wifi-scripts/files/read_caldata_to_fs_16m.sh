#!/bin/sh
#
# Copyright (c) 2015, 2020, The Linux Foundation. All rights reserved.
# Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.

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

. /lib/functions.sh
. /lib/create_cfg_caldata.sh

do_load_ipq4019_board_bin()
{

    local board=ap$(echo $(board_name) | awk -F 'ap' '{print$2}')
    local mtdblock=$(find_mtd_part 0:ART)

    local apdk="/tmp"

    if [ -z "$mtdblock" ]; then
        # read from mmc
        mtdblock=$(find_mmc_part 0:ART)
    fi

    [ -n "$mtdblock" ] || return

    # load board.bin
    case "$board" in
            ap-mi01.3*|ap-mi04.1*)
                    [ -f /lib/firmware/IPQ5332/caldata.bin ] && return
                    mkdir -p ${apdk}/IPQ5332
                    mkdir -p ${apdk}/qcn6432
                    do_ftm_conf_override

                    if [ -e /sys/firmware/devicetree/base/compressed_art ]
                    then
                        #FTM Daemon compresses the caldata and writes the lzma file in ART Partition
                        dd if=${mtdblock} of=${apdk}/virtual_art.bin.lzma
                        lzma -fdv --single-stream ${apdk}/virtual_art.bin.lzma || {
                        # Create dummy virtual_art.bin file of size 256K
                        dd if=/dev/zero of=${apdk}/virtual_art.bin bs=1024 count=256
                        }

                        create_cfg_caldata "${apdk}/virtual_art.bin" "IPQ5332" "qcn6432" "0" 
                    else
                    	create_cfg_caldata "${mtdblock}" "IPQ5332" "qcn6432" "0" 
                    fi
            ;;
            ap-mi*)
                    [ -f /lib/firmware/IPQ5332/caldata.bin ] && return
                    mkdir -p ${apdk}/IPQ5332
                    create_cfg_caldata "${mtdblock}" "IPQ5332"
            ;;
   esac
}

