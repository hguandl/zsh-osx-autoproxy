#!/bin/zsh
# Auto configure zsh proxy env based on system preferences
# Sukka (https://skk.moe)
# hguandl (https://hguandl.com)

() {
    local scutil_output=$(scutil --proxy)
    local -A info=(${(pws: :)${${(M)${(f)scutil_output}:# *[A-Za-z] : [A-Za-z0-9]*}/:}})
    local -A exceptions=(${(pws: :)${${(M)${(f)scutil_output}:# *[0-9] : [A-Za-z0-9/\*]*}/:}})

    # HTTP Proxy
    if (( $info[HTTPEnable] )); then
        export http_proxy="http://$info[HTTPProxy]:$info[HTTPPort]"
        export HTTP_PROXY="$http_proxy"
    fi

    # HTTPS Proxy
    if (( $info[HTTPSEnable] )); then
        export https_proxy="http://$info[HTTPSProxy]:$info[HTTPSPort]"
        export HTTPS_PROXY="$https_proxy"
    fi

    # FTP Proxy
    if (( $info[FTPEnable] )); then
        export ftp_proxy="http://$info[FTPProxy]:$info[FTPPort]"
        export FTP_PROXY="$ftp_proxy"
    fi

    # All Proxy
    if (( $info[SOCKSEnable] )); then
        export all_proxy="socks5h://$info[SOCKSProxy]:$info[SOCKSPort]"
        export ALL_PROXY="$all_proxy"
    elif (( $info[HTTPEnable] )); then
        export all_proxy="$http_proxy"
        export ALL_PROXY="$all_proxy"
    fi

    # No Proxy
    export no_proxy="${(j:,:)exceptions}"
}
