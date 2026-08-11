#!/bin/bash

# ============================================================
# ensure_os.sh
# Extended OS detection
#
# Compatible with old Bash versions, including CentOS 6.
#
# Created with care by ChatGPT
# GPT-5.6 Luna - OpenAI
# ============================================================

OS=""
OS_ID=""
OS_VERSION=""
OS_MAJOR=""
OS_MINOR=""
OS_PATCH=""
OS_FAMILY=""
OS_KERNEL=""
OS_KERNEL_VERSION=""
OS_ARCH=""
OS_ENVIRONMENT=""

OS_KERNEL="$(uname -s 2>/dev/null)"
OS_KERNEL_VERSION="$(uname -r 2>/dev/null)"
OS_ARCH="$(uname -m 2>/dev/null)"

# ============================================================
# Windows / Cygwin / MSYS / MinGW
# ============================================================

case "$OS_KERNEL" in
    CYGWIN_NT-*)
        OS="Windows"
        OS_ID="windows"
        OS_FAMILY="windows"
        OS_ENVIRONMENT="cygwin"
        ;;
    MSYS_NT-*)
        OS="Windows"
        OS_ID="windows"
        OS_FAMILY="windows"
        OS_ENVIRONMENT="msys"
        ;;
    MINGW*)
        OS="Windows"
        OS_ID="windows"
        OS_FAMILY="windows"
        OS_ENVIRONMENT="mingw"
        ;;
esac

if [ "$OS_FAMILY" = "windows" ]; then
    if command -v cmd.exe >/dev/null 2>&1; then
        WINDOWS_VERSION="$(cmd.exe /c ver 2>/dev/null | tr -d '\r')"

        case "$WINDOWS_VERSION" in
            *"Windows 11"*) OS="Windows 11" ;;
            *"Windows 10"*) OS="Windows 10" ;;
            *"Windows Server 2025"*) OS="Windows Server 2025" ;;
            *"Windows Server 2022"*) OS="Windows Server 2022" ;;
            *"Windows Server 2019"*) OS="Windows Server 2019" ;;
            *"Windows Server 2016"*) OS="Windows Server 2016" ;;
            *"Windows Server 2012 R2"*) OS="Windows Server 2012 R2" ;;
            *"Windows Server 2012"*) OS="Windows Server 2012" ;;
            *"Windows Server 2008 R2"*) OS="Windows Server 2008 R2" ;;
            *"Windows Server 2008"*) OS="Windows Server 2008" ;;
            *"Windows Server 2003"*) OS="Windows Server 2003" ;;
            *"Windows 8.1"*) OS="Windows 8.1" ;;
            *"Windows 8"*) OS="Windows 8" ;;
            *"Windows 7"*) OS="Windows 7" ;;
            *"Windows Vista"*) OS="Windows Vista" ;;
            *"Windows XP"*) OS="Windows XP" ;;
            *"Windows 2000"*) OS="Windows 2000" ;;
            *"Windows NT"*) OS="Windows NT" ;;
        esac

        OS_VERSION="$(echo "$WINDOWS_VERSION" | sed -n 's/.*Version \([^)]*\).*/\1/p')"
    fi
fi

# ============================================================
# macOS / Darwin
# ============================================================

if [ -z "$OS" ] && [ "$OS_KERNEL" = "Darwin" ]; then
    OS="macOS"
    OS_ID="darwin"
    OS_FAMILY="darwin"
    OS_ENVIRONMENT="macos"

    if [ -x /usr/bin/sw_vers ]; then
        OS_VERSION="$(/usr/bin/sw_vers -productVersion 2>/dev/null)"
    fi
fi

# ============================================================
# BSD
# ============================================================

if [ -z "$OS" ]; then
    case "$OS_KERNEL" in
        FreeBSD)
            OS="FreeBSD"
            OS_ID="freebsd"
            OS_FAMILY="bsd"
            OS_ENVIRONMENT="bsd"
            OS_VERSION="$OS_KERNEL_VERSION"
            ;;
        OpenBSD)
            OS="OpenBSD"
            OS_ID="openbsd"
            OS_FAMILY="bsd"
            OS_ENVIRONMENT="bsd"
            OS_VERSION="$OS_KERNEL_VERSION"
            ;;
        NetBSD)
            OS="NetBSD"
            OS_ID="netbsd"
            OS_FAMILY="bsd"
            OS_ENVIRONMENT="bsd"
            OS_VERSION="$OS_KERNEL_VERSION"
            ;;
        DragonFly)
            OS="DragonFly BSD"
            OS_ID="dragonfly"
            OS_FAMILY="bsd"
            OS_ENVIRONMENT="bsd"
            OS_VERSION="$OS_KERNEL_VERSION"
            ;;
    esac
fi

# ============================================================
# Linux
# ============================================================

if [ -z "$OS" ] && [ "$OS_KERNEL" = "Linux" ]; then
    OS_ENVIRONMENT="linux"

    # --------------------------------------------------------
    # /etc/os-release
    # --------------------------------------------------------

    if [ -s /etc/os-release ] && grep -q '^ID=' /etc/os-release 2>/dev/null; then
        . /etc/os-release

        OS_ID="$ID"
        OS="${NAME:-$ID}"
        OS_VERSION="$VERSION_ID"

        case "$OS_ID" in
            rhel|redhat|redhatlinux|centos|almalinux|rocky|ol|oracle|oraclelinux|eurolinux|miraclelinux|springdale|scientific|scientificlinux|scientificsl|navy|circle)
                OS_FAMILY="rhel"
                ;;
            amzn|amazon|amazonlinux|amazon-linux)
                OS_FAMILY="rhel"
                ;;
            fedora|nobara|ultramarine|qubes)
                OS_FAMILY="fedora"
                ;;
            arch|archlinux|blackarch|artix|manjaro|endeavouros|garuda|cachyos|parabola|rebornos|arcolinux|blendos|archcraft|archlabs|anarchy)
                OS_FAMILY="arch"
                ;;
            debian|ubuntu|linuxmint|mint|elementary|pop|pop_os|kali|parrot|mx|deepin|neurodebian|trisquel|pureos|devuan|antix|bodhi|lxle|peppermint|zorin|kubuntu|xubuntu|lubuntu|edubuntu|ubuntustudio|ubuntu-mate|ubuntu-budgie|ubuntu-unity|ubuntu-cinnamon|ubuntu-kylin|raspbian|dietpi|knoppix|gnewsense|musix|osmc|caelinux|endless|endlessos|steamos|librem|vanilla|vanillaos|pardus)
                OS_FAMILY="debian"
                ;;
            opensuse|opensuse-leap|opensuse-tumbleweed|opensuse-slowroll|sles|sled|suse|aeon|kalpa)
                OS_FAMILY="suse"
                ;;
            gentoo|funtoo|calculate|pentoo|redcore|sabayon|ututo)
                OS_FAMILY="gentoo"
                ;;
            alpine|wolfi|chainguard)
                OS_FAMILY="alpine"
                ;;
            slackware|salix|slackel|zenwalk|vectorlinux|absolute)
                OS_FAMILY="slackware"
                ;;
            void|voidlinux)
                OS_FAMILY="void"
                ;;
            mageia|mandriva|mandrake|rosa|openmandriva)
                OS_FAMILY="mandriva"
                ;;
            pclinuxos)
                OS_FAMILY="pclinuxos"
                ;;
            nixos|nix)
                OS_FAMILY="nixos"
                ;;
            guix)
                OS_FAMILY="guix"
                ;;
            clear-linux-os|clearlinux)
                OS_FAMILY="clearlinux"
                ;;
            puppy|puppylinux)
                OS_FAMILY="puppy"
                ;;
            tinycore|tinycorelinux)
                OS_FAMILY="tinycore"
                ;;
            crux)
                OS_FAMILY="crux"
                ;;
            kaos)
                OS_FAMILY="kaos"
                ;;
            chimera|chimera-linux)
                OS_FAMILY="chimera"
                ;;
            chromeos|chromiumos|chromium)
                OS_FAMILY="chromeos"
                ;;
            bazzite|ublue|bazzite-arch)
                OS_FAMILY="fedora"
                ;;
            gobo|gobolinux)
                OS_FAMILY="gobo"
                ;;
            bedrock)
                OS_FAMILY="bedrock"
                ;;
            dragora)
                OS_FAMILY="dragora"
                ;;
            4mlinux)
                OS_FAMILY="4mlinux"
                ;;
            slitaz)
                OS_FAMILY="slitaz"
                ;;
            frugalware)
                OS_FAMILY="frugalware"
                ;;
            openwrt|lede)
                OS_FAMILY="openwrt"
                ;;
            0linux)
                OS_FAMILY="0linux"
                ;;
            altlinux|alt)
                OS_FAMILY="altlinux"
                ;;
            hanthana)
                OS_FAMILY="fedora"
                ;;
            *)
                OS_FAMILY=""
                ;;
        esac

        if [ -z "$OS_FAMILY" ]; then
            if echo " $ID_LIKE " | grep -qiE 'rhel|centos|fedora'; then
                OS_FAMILY="rhel"
            elif echo " $ID_LIKE " | grep -qiE 'debian|ubuntu'; then
                OS_FAMILY="debian"
            elif echo " $ID_LIKE " | grep -qiE 'arch'; then
                OS_FAMILY="arch"
            elif echo " $ID_LIKE " | grep -qiE 'suse'; then
                OS_FAMILY="suse"
            elif echo " $ID_LIKE " | grep -qiE 'gentoo'; then
                OS_FAMILY="gentoo"
            elif echo " $ID_LIKE " | grep -qiE 'alpine'; then
                OS_FAMILY="alpine"
            else
                OS_FAMILY="$OS_ID"
            fi
        fi
    fi

    # --------------------------------------------------------
    # /usr/lib/os-release
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -s /usr/lib/os-release ] && grep -q '^ID=' /usr/lib/os-release 2>/dev/null; then
        . /usr/lib/os-release

        OS_ID="$ID"
        OS="${NAME:-$ID}"
        OS_VERSION="$VERSION_ID"

        if echo " $ID_LIKE " | grep -qiE 'rhel|centos|fedora'; then
            OS_FAMILY="rhel"
        elif echo " $ID_LIKE " | grep -qiE 'debian|ubuntu'; then
            OS_FAMILY="debian"
        elif echo " $ID_LIKE " | grep -qiE 'arch'; then
            OS_FAMILY="arch"
        elif echo " $ID_LIKE " | grep -qiE 'suse'; then
            OS_FAMILY="suse"
        elif echo " $ID_LIKE " | grep -qiE 'gentoo'; then
            OS_FAMILY="gentoo"
        elif echo " $ID_LIKE " | grep -qiE 'alpine'; then
            OS_FAMILY="alpine"
        else
            OS_FAMILY="$OS_ID"
        fi
    fi

    # --------------------------------------------------------
    # Amazon Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/system-release ]; then
        RELEASE="$(cat /etc/system-release 2>/dev/null)"

        case "$RELEASE" in
            Amazon\ Linux*)
                OS="Amazon Linux"
                OS_ID="amzn"
                OS_FAMILY="rhel"
                OS_VERSION="$(echo "$RELEASE" | sed 's/^.*release //;s/ (.*$//')"
                ;;
        esac
    fi

    # --------------------------------------------------------
    # CentOS
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/centos-release ]; then
        RELEASE_FILE="$(readlink -f /etc/centos-release 2>/dev/null)"

        if [ -n "$RELEASE_FILE" ] && [ -f "$RELEASE_FILE" ]; then
            RELEASE="$(cat "$RELEASE_FILE" 2>/dev/null)"

            case "$RELEASE" in
                CentOS*)
                    OS="CentOS"
                    OS_ID="centos"
                    OS_FAMILY="rhel"
                    OS_VERSION="$(echo "$RELEASE" | sed 's/^.*release //;s/ (.*$//')"
                    ;;
            esac
        fi
    fi

    # --------------------------------------------------------
    # RHEL
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/redhat-release ]; then
        RELEASE="$(cat /etc/redhat-release 2>/dev/null)"

        case "$RELEASE" in
            Red\ Hat\ Enterprise\ Linux*)
                OS="Red Hat Enterprise Linux"
                OS_ID="rhel"
                OS_FAMILY="rhel"
                OS_VERSION="$(echo "$RELEASE" | sed 's/^.*release //;s/ (.*$//')"
                ;;
        esac
    fi

    # --------------------------------------------------------
    # AlmaLinux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/almalinux-release ]; then
        OS="AlmaLinux"
        OS_ID="almalinux"
        OS_FAMILY="rhel"
        OS_VERSION="$(cat /etc/almalinux-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Rocky Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/rocky-release ]; then
        OS="Rocky Linux"
        OS_ID="rocky"
        OS_FAMILY="rhel"
        OS_VERSION="$(cat /etc/rocky-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Oracle Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/oracle-release ]; then
        OS="Oracle Linux"
        OS_ID="ol"
        OS_FAMILY="rhel"
        OS_VERSION="$(cat /etc/oracle-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Scientific Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/sl-release ]; then
        OS="Scientific Linux"
        OS_ID="scientific"
        OS_FAMILY="rhel"
        OS_VERSION="$(cat /etc/sl-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Debian
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/debian_version ]; then
        OS="Debian"
        OS_ID="debian"
        OS_FAMILY="debian"
        OS_VERSION="$(cat /etc/debian_version 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # LSB
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/lsb-release ]; then
        LSB_ID="$(sed -n 's/^DISTRIB_ID=//p' /etc/lsb-release)"
        LSB_VERSION="$(sed -n 's/^DISTRIB_RELEASE=//p' /etc/lsb-release)"

        if [ -n "$LSB_ID" ]; then
            OS="$LSB_ID"
            OS_ID="$(echo "$LSB_ID" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
            OS_VERSION="$LSB_VERSION"
            OS_FAMILY="debian"
        fi
    fi

    # --------------------------------------------------------
    # Fedora
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/fedora-release ]; then
        OS="Fedora"
        OS_ID="fedora"
        OS_FAMILY="fedora"
        OS_VERSION="$(cat /etc/fedora-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Alpine
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/alpine-release ]; then
        OS="Alpine Linux"
        OS_ID="alpine"
        OS_FAMILY="alpine"
        OS_VERSION="$(cat /etc/alpine-release 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # Arch Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/arch-release ]; then
        OS="Arch Linux"
        OS_ID="arch"
        OS_FAMILY="arch"
        OS_VERSION="rolling"
    fi

    # --------------------------------------------------------
    # Gentoo
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/gentoo-release ]; then
        OS="Gentoo"
        OS_ID="gentoo"
        OS_FAMILY="gentoo"
        OS_VERSION="$(cat /etc/gentoo-release 2>/dev/null | sed 's/^.*release //')"
    fi

    # --------------------------------------------------------
    # Funtoo
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/funtoo-release ]; then
        OS="Funtoo"
        OS_ID="funtoo"
        OS_FAMILY="gentoo"
        OS_VERSION="$(cat /etc/funtoo-release 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # Slackware
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/slackware-version ]; then
        OS="Slackware"
        OS_ID="slackware"
        OS_FAMILY="slackware"
        OS_VERSION="$(cat /etc/slackware-version 2>/dev/null | sed 's/^Slackware //')"
    fi

    # --------------------------------------------------------
    # Old SUSE
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/SuSE-release ]; then
        OS="SUSE"
        OS_ID="suse"
        OS_FAMILY="suse"
        OS_VERSION="$(sed -n 's/^VERSION = //p' /etc/SuSE-release | head -n 1)"
    fi

    # --------------------------------------------------------
    # Mageia
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/mageia-release ]; then
        OS="Mageia"
        OS_ID="mageia"
        OS_FAMILY="mandriva"
        OS_VERSION="$(cat /etc/mageia-release 2>/dev/null | sed 's/^.*release //;s/ (.*$//')"
    fi

    # --------------------------------------------------------
    # Void Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/void-release ]; then
        OS="Void Linux"
        OS_ID="void"
        OS_FAMILY="void"
        OS_VERSION="rolling"
    fi

    # --------------------------------------------------------
    # Puppy Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/DISTRO_SPECS ]; then
        if grep -q '^DISTRO_NAME=' /etc/DISTRO_SPECS 2>/dev/null; then
            OS="$(sed -n 's/^DISTRO_NAME=//p' /etc/DISTRO_SPECS)"
            OS_ID="puppy"
            OS_FAMILY="puppy"
            OS_VERSION="$(sed -n 's/^DISTRO_VERSION=//p' /etc/DISTRO_SPECS)"
        fi
    fi

    # --------------------------------------------------------
    # Tiny Core Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/tc-version ]; then
        OS="Tiny Core Linux"
        OS_ID="tinycore"
        OS_FAMILY="tinycore"
        OS_VERSION="$(cat /etc/tc-version 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # NixOS
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/NIXOS ]; then
        OS="NixOS"
        OS_ID="nixos"
        OS_FAMILY="nixos"
    fi

    # --------------------------------------------------------
    # 0Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ]; then
        if [ -f /etc/0linux-release ] || \
           [ -f /etc/0linux-version ] || \
           [ -f /etc/0linux_version ] || \
           [ -d /etc/0linux ]; then

            OS="0Linux"
            OS_ID="0linux"
            OS_FAMILY="0linux"

            if [ -f /etc/0linux-release ]; then
                OS_VERSION="$(cat /etc/0linux-release 2>/dev/null)"
            elif [ -f /etc/0linux-version ]; then
                OS_VERSION="$(cat /etc/0linux-version 2>/dev/null)"
            elif [ -f /etc/0linux_version ]; then
                OS_VERSION="$(cat /etc/0linux_version 2>/dev/null)"
            fi
        fi
    fi

    # --------------------------------------------------------
    # OpenWrt
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/openwrt_release ]; then
        OS="OpenWrt"
        OS_ID="openwrt"
        OS_FAMILY="openwrt"
        OS_VERSION="$(sed -n "s/^DISTRIB_RELEASE='\(.*\)'/\1/p" /etc/openwrt_release)"
    fi

    # --------------------------------------------------------
    # KNOPPIX
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/knoppix_version ]; then
        OS="KNOPPIX"
        OS_ID="knoppix"
        OS_FAMILY="debian"
        OS_VERSION="$(cat /etc/knoppix_version 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # Raspbian
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /etc/rpi-issue ]; then
        OS="Raspbian"
        OS_ID="raspbian"
        OS_FAMILY="debian"
        OS_VERSION="$(cat /etc/rpi-issue 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # DietPi
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /boot/dietpi/.version ]; then
        OS="DietPi"
        OS_ID="dietpi"
        OS_FAMILY="debian"
        OS_VERSION="$(sed -n 's/^VER=\(.*\)/\1/p' /boot/dietpi/.version)"
    fi

    # --------------------------------------------------------
    # Bedrock Linux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /bedrock/etc/bedrock-release ]; then
        OS="Bedrock Linux"
        OS_ID="bedrock"
        OS_FAMILY="bedrock"
        OS_VERSION="$(cat /bedrock/etc/bedrock-release 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # GoboLinux
    # --------------------------------------------------------

    if [ -z "$OS_ID" ] && [ -f /System/Settings/Version ]; then
        OS="GoboLinux"
        OS_ID="gobo"
        OS_FAMILY="gobo"
        OS_VERSION="$(cat /System/Settings/Version 2>/dev/null)"
    fi

    # --------------------------------------------------------
    # Generic fallback for historical/custom distributions
    # --------------------------------------------------------

    if [ -z "$OS_ID" ]; then
        for RELEASE_FILE in /etc/*-release /etc/*_release /etc/*-version /etc/*_version; do
            [ -f "$RELEASE_FILE" ] || continue

            case "$RELEASE_FILE" in
                /etc/os-release|/etc/system-release|/etc/redhat-release|/etc/centos-release|/etc/almalinux-release|/etc/rocky-release|/etc/oracle-release|/etc/sl-release|/etc/fedora-release|/etc/debian_version|/etc/lsb-release|/etc/alpine-release|/etc/arch-release|/etc/gentoo-release|/etc/funtoo-release|/etc/slackware-version|/etc/SuSE-release|/etc/mageia-release|/etc/void-release|/etc/0linux-release|/etc/0linux-version|/etc/0linux_version)
                    continue
                    ;;
            esac

            RELEASE_TEXT="$(head -n 1 "$RELEASE_FILE" 2>/dev/null)"

            if [ -n "$RELEASE_TEXT" ]; then
                OS="Linux"
                OS_ID="$(basename "$RELEASE_FILE")"
                OS_ID="${OS_ID%-release}"
                OS_ID="${OS_ID%_release}"
                OS_ID="${OS_ID%-version}"
                OS_ID="${OS_ID%_version}"
                OS_FAMILY="linux"
                OS_VERSION="$RELEASE_TEXT"
                break
            fi
        done
    fi

    # --------------------------------------------------------
    # Linux fallback
    # --------------------------------------------------------

    if [ -z "$OS_ID" ]; then
        OS="Linux"
        OS_ID="linux"
        OS_FAMILY="linux"
    fi
fi

# ============================================================
# Version parsing
# ============================================================

if [ -n "$OS_VERSION" ] && [ "$OS_VERSION" != "rolling" ]; then
    OS_MAJOR="${OS_VERSION%%.*}"
    OS_TMP="${OS_VERSION#*.}"

    if [ "$OS_TMP" != "$OS_VERSION" ]; then
        OS_MINOR="${OS_TMP%%.*}"
    fi

    OS_TMP="${OS_TMP#*.}"

    if [ -n "$OS_TMP" ] && [ "$OS_TMP" != "$OS_VERSION" ]; then
        OS_PATCH="${OS_TMP%%.*}"
    fi
fi

# ============================================================
# Final fallback
# ============================================================

if [ -z "$OS" ]; then
    OS="Unknown"
    OS_ID="unknown"
    OS_FAMILY="unknown"
    OS_ENVIRONMENT="unknown"
fi

# ============================================================
# Export
# ============================================================

export OS
export OS_ID
export OS_VERSION
export OS_MAJOR
export OS_MINOR
export OS_PATCH
export OS_FAMILY
export OS_KERNEL
export OS_KERNEL_VERSION
export OS_ARCH
export OS_ENVIRONMENT

# ============================================================
# End
# Created with care by ChatGPT - GPT-5.6 Luna
# ============================================================
