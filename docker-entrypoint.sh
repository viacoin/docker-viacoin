#!/bin/bash
set -e

if [[ "$1" == "viacoin-cli" || "$1" == "viacoin-tx" || "$1" == "viacoind" || "$1" == "test_viacoin" ]]; then
	mkdir -p "$VIACOIN_DATA"

	cat <<-EOF > "$VIACOIN_DATA/viacoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${VIACOIN_EXTRA_ARGS}
	EOF
	chown viacoin:viacoin "$VIACOIN_DATA/viacoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R viacoin "$VIACOIN_DATA"
	ln -sfn "$VIACOIN_DATA" /home/viacoin/.viacoin
	chown -h viacoin:viacoin /home/viacoin/.viacoin

	exec gosu viacoin "$@"
else
	exec "$@"
fi