#!/bin/sh
set -eu

# Headless (non-desktop) prep, run as the tutabridge user before the
# daemon starts. Mirrors what the official container entrypoint does:
# seed config.toml (ports + pass session backend) and initialize a
# passphrase-less GPG key + `pass init` so the bridge can persist its
# Tuta session without a desktop keyring (Secret Service). Idempotent:
# existing config and password store are left untouched.

umask 077
export XDG_CONFIG_HOME="@DATA@/config"
export XDG_CACHE_HOME="@DATA@/cache"
export GNUPGHOME="@DATA@/gnupg"
export PASSWORD_STORE_DIR="@DATA@/pass"
export PASSWORD_STORE_GPG_OPTS="--batch --pinentry-mode error"

mkdir -p "$XDG_CONFIG_HOME/tutabridge" "$XDG_CACHE_HOME" "$GNUPGHOME" "$PASSWORD_STORE_DIR"
chmod 700 "$GNUPGHOME" "$PASSWORD_STORE_DIR"

config="$XDG_CONFIG_HOME/tutabridge/config.toml"
if [ ! -e "$config" ]; then
  cat >"$config" <<EOF
email = "@EMAIL@"
imap_port = @IMAP_PORT@
smtp_port = @SMTP_PORT@
# keep the session in the password store instead of a desktop keyring
pass_path = "Tuta/Bridge"
# never contact GitHub on our own; upgrades come from the flake
auto_update = false
EOF
  chmod 600 "$config"
fi

# one private, unprotected GPG key owns the password store
if [ ! -e "$PASSWORD_STORE_DIR/.gpg-id" ]; then
  # generate a key only when the keyring is still empty
  if [ -z "$(gpg --batch --no-autostart --with-colons --list-secret-keys |
      grep -m1 '^sec:')" ]; then
    # batch keygen: no TTY, no pinentry prompt, unprotected (passphrase-less)
    # key -- `pass` can then use it non-interactively
    printf "Key-Type: RSA\nKey-Length: 3072\nSubkey-Type: RSA\nSubkey-Length: 3072\nName-Real: TutaBridge\nName-Email: tutabridge@localhost\nExpire-Date: 0\n%%commit\n" |
      gpg --batch --pinentry-mode loopback --passphrase "" --gen-key -
  fi
  # exactly one (40-hex) primary-key fingerprint must own the store
  keys=$(gpg --batch --no-autostart --with-colons --list-secret-keys |
    awk -F: '$1 == "fpr" && !seen { print $10; seen = 1 }')
  if [ "$(printf '%s\n' "$keys" | wc -l)" -ne 1 ] ||
    ! printf '%s\n' "$keys" | grep -Eq '^[A-F0-9]{40}$'; then
    echo "tutabridge: expected exactly one private GPG key, got: $keys" >&2
    exit 1
  fi
  pass init "$keys" >/dev/null
fi
