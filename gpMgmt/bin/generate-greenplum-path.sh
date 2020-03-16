#!/usr/bin/env bash

if [ x$1 != x ] ; then
    GPHOME_PATH="$1"
else
    GPHOME_PATH="\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" >/dev/null 2>&1 && pwd )"
fi

cat <<-EOF
#!/usr/bin/env bash
GPHOME="${GPHOME_PATH}"
EOF

cat <<EOF
PYTHONHOME="\${GPHOME}/ext/python"
PYTHONPATH="\${GPHOME}/lib/python"
PATH="\${GPHOME}/bin:\${PYTHONHOME}/bin:\${PATH}"
LD_LIBRARY_PATH="\${GPHOME}/lib:\${PYTHONHOME}/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"

# openssl configuration file path
if [ -e "\$GPHOME/etc/openssl.cnf" ]; then
	OPENSSL_CONF="\$GPHOME/etc/openssl.cnf"
fi

export GPHOME
export PATH
export PYTHONHOME
export PYTHONPATH
export LD_LIBRARY_PATH
export OPENSSL_CONF
EOF
