# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for LokiNET"
ACCT_USER_ID=515
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME=/etc/lokinet

acct-user_add_deps

