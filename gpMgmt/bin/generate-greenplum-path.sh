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


PLAT=`uname -s`
if [ $? -ne 0 ] ; then
    echo "Error executing uname -s"
    exit 1
fi

cat <<EOF

PYTHONHOME="\${GPHOME}/ext/python"
PYTHONPATH="\${GPHOME}/lib/python"
PATH="\${GPHOME}/bin:\${PYTHONHOME}/bin:\${PATH}"
LD_LIBRARY_PATH="\${GPHOME}/lib:\${PYTHONHOME}/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
EOF

# AIX uses yet another library path variable
# Also, Python on AIX requires special copies of some libraries.  Hence, lib/pware.
if [ "${PLAT}" = "AIX" ]; then
cat <<EOF
PYTHONPATH="\${GPHOME}/ext/python/lib/python2.7:\${PYTHONPATH}"
LIBPATH="\${GPHOME}/lib/pware:\${GPHOME}/lib:\${GPHOME}/ext/python/lib:/usr/lib/threads:\${LIBPATH}"
export LIBPATH
GP_LIBPATH_FOR_PYTHON="\${GPHOME}/lib/pware"
export GP_LIBPATH_FOR_PYTHON
EOF
fi

# openssl configuration file path
cat <<EOF

if [ -e "\$GPHOME/etc/openssl.cnf" ]; then
   OPENSSL_CONF="\$GPHOME/etc/openssl.cnf"
fi
EOF

cat <<EOF

export GPHOME
export PATH
export PYTHONHOME
export PYTHONPATH
export LD_LIBRARY_PATH
export OPENSSL_CONF
EOF
