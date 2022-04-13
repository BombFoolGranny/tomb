#!/usr/bin/env zsh

export test_description="Testing tomb with GnuPG keys"

source ./setup

if test_have_prereq GPGRCPT; then

test_export "recipient"
test_expect_success 'Testing tomb with GnuPG keys: creation' '
    tt_dig -s 20 &&
    tt_forge -g -r $KEY1 &&
    tt_lock -g -r $KEY1
    '

test_expect_success 'Testing tomb with GnuPG keys: open & close' '
    tt_open -g &&
    tt_close
    '

test_export "default"
test_expect_success 'Testing tomb with GnuPG keys using the default recipient' '
    tt_dig -s 20 &&
    tt_forge -g &&
    tt_lock -g &&
    gpg -d --status-fd 2 $tomb_key 1> /dev/null 2> $TMP/default.tmp &&
    [[ ! -z "$(grep "Tomb Test 2" $TMP/default.tmp)" ]]
    '

test_export "hidden"
test_expect_success 'Testing tomb with GnuPG keys using hidden recipient' '
    tt_dig -s 20 &&
    tt_forge -g -R $KEY1 &&
    tt_lock -g -R $KEY1
    '

test_export "subkeys"
test_expect_success 'Testing tomb with GnuPG subkeys' '
    tt_dig -s 20 &&
    tt_forge -g -R $SUBKEY2 &&
    tt_lock -g -R $SUBKEY2
    '

test_export "shared"
test_expect_success 'Testing tomb with GnuPG keys and shared tomb' '
    tt_dig -s 20 &&
    tt_forge -g -r $KEY1,$KEY2 &&
    tt_lock -g -r $KEY1 &&
    tt_open -g &&
    tt_close
    '

test_export "untrusted"
test_expect_success 'Testing tomb creation with untrusted GnuPG keys' '
    tt_dig -s 20 &&
    test_must_fail tt_forge -g -r $KEY_UNTRUSTED
    '

fi

test_done
