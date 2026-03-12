#!/bin/sh
#  		Licensed Materials - Property of IBM
#  			xxxx-xxx
#  		 Copyright IBM Corporation 2019, 2024. All rights reserved.
#  		US Government Users Restricted Rights - Use, duplication or disclosure
#  		restricted by GSA ADP Schedule Contract with IBM Corp.
#  
#  The source code for this program is not published or otherwise
#  divested of its trade secrets, irrespective of what has been
#  deposited with the U.S. Copyright Office.
#
#  Shell script to start the z/OS Debugger Remote Debug Service
#
# ======================================================================================================
# The following environment variables should be supplied to this script:
#
#  EQARMTD_BASE 
#   - the installation directory of the z/OS Debugger.
#   - Default is /usr/lpp/IBM/debug/remote-debug-service
#
#  EQARMTD_CFG_DIR 
#   - the directory containing configuration files for the Remote Debug Service.
#   - Default is /etc/debug
#
#  EQARMTD_WRK_DIR 
#   - the directory for Remote Debug Service working files.
#   - Default is /var/debug
#
#  EQARMTD_ENVFILE 
#   - the installation configuration file, containing runtime configuration of the Remote Debug Service
#   - Default is $EQARMTD_CFG_DIR/eqarmtd.env
#
# ======================================================================================================

# -----------------------------------------------------------------------------------------------------
# Print out some version numbers
# -----------------------------------------------------------------------------------------------------
_EQARMTD_SCRIPT_VERSION="Jan21,2025"
_EQARMTD_SCRIPT_PATH="`dirname \"$0\"`"
_launcher=launcher.jar

echo ***NJL Trace: $(dirname "$0")  


echo Remote Debug Service script version $_EQARMTD_SCRIPT_VERSION
_BUILD_VERSION=$(cat $_EQARMTD_SCRIPT_PATH/../version.properties | sed -n 's/.*version=\(.*\)/\1/p')
echo Remote Debug Service build $_BUILD_VERSION

# -----------------------------------------------------------------------------------------------------
# Initialize the mandatory environment variables to their defaults if they are not already defined
# -----------------------------------------------------------------------------------------------------
if [ -z "${EQARMTD_BASE}" ]; then
  EQARMTD_BASE="/usr/lpp/IBM/debug/remote-debug-service"
fi
if [ -z "${EQARMTD_CFG_DIR}" ]; then
  EQARMTD_CFG_DIR="/etc/debug"
fi
if [ -z "${EQARMTD_WRK_DIR}" ]; then
  EQARMTD_WRK_DIR="/var/debug"
fi
if [ -z "${EQARMTD_ENVFILE}" ]; then
  EQARMTD_ENVFILE="$EQARMTD_CFG_DIR/eqarmtd.env"
fi


# -----------------------------------------------------------------------------------------------------
# Get the installation configuration
# -----------------------------------------------------------------------------------------------------
if [ -r "$EQARMTD_ENVFILE" ]; then
  . "$EQARMTD_ENVFILE"
else
  echo "The installation configuration file defined in environment variable EQARMTD_ENVFILE is missing or unreadable"
  echo EQARMTD_ENVFILE=$EQARMTD_ENVFILE
  exit 1
fi


# -----------------------------------------------------------------------------------------------------
# Validate Java
# -----------------------------------------------------------------------------------------------------
export JAVA_HOME="${java_dir}"
if test -x "$JAVA_HOME/bin/java"
then
  echo using $JAVA_HOME/bin/java
  $JAVA_HOME/bin/java -fullversion
else
  echo $JAVA_HOME/bin/java could not be located.
  echo Examine and update the value of java_dir within $EQARMTD_ENVFILE 
  exit 1
fi



# -----------------------------------------------------------------------------------------------------
# Construct the command line options for the port options
# -----------------------------------------------------------------------------------------------------
if [ "${allow_unsecured_remote_connections}" = "true" ] || [ "${allow_unsecured_remote_connections}" = "TRUE" ]; then
  # unsecured mode listening on ${port_internal} for both local engine-adapter connections and remote client-adapter connections
  echo "internal port: ${port_internal}"
  echo "external port: ${port_internal}"
  UNSECURE_ARGS="-port=${port_internal}"
else
  # unsecured mode listening on ${port_internal} for local engine-adapter connections only 
  echo "internal port: ${port_internal} (localhost only)"
  UNSECURE_ARGS="-port=${port_internal} -localonly"
fi


# unsecured mode listening on ${port_external} for remote client-adapter connections
if [ -n "${port_external}" ]; then
  echo "external port: ${port_external}"
  UNSECURE_ARGS="$UNSECURE_ARGS -externalport=${port_external}"
fi


# secured mode listening on ${port_external_secure} for remote client-adapter connections
if [ -n "${port_external_secure}" ]; then
  echo "secured port: ${port_external_secure}"
  SECURE_ARGS="-secureport=${port_external_secure}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -Dkeystore=${keystoreFile} -Dkeystorepassword=${keystorePass} -Dkeystorepasswordfile=${keystorePassFile}"
fi

# -----------------------------------------------------------------------------------------------------
# Construct the command line options for the code coverage options
# -----------------------------------------------------------------------------------------------------
if [ "${headless_cc}" = "true" ] || [ "${headless_cc}" = "TRUE" ]; then
  echo "Headless code coverage: enabled"
  CC_ARGS="-Imode=ANY"
  if [ -n ${headless_cc_config} ]; then
  	echo "Headless code coverage config: ${headless_cc_config}"
  	CC_ARGS="${CC_ARGS} -ccoptions=${headless_cc_config} "
  fi
else
  echo "Headless code coverage: disabled"
  CC_ARGS="-Imode=DEBUG"
fi


# -----------------------------------------------------------------------------------------------------
# Construct the Java system properties based on the entries in the configuration file
# -----------------------------------------------------------------------------------------------------

# advertise port configuration to the API server
if [ -n "${advertise_port_config}" ]; then
  echo "advertise_port_config: ${advertise_port_config}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DADVERTISE_PORT_CONFIG=${advertise_port_config}"
fi

# default variables filter
if [ -n "${default_variables_filter}" ]; then
  echo "default_variables_filter: ${default_variables_filter}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DDEFAULT_VARIABLES_FILTER=${default_variables_filter}"
else
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DDEFAULT_VARIABLES_FILTER=ALL"
fi

# CCS max requests per second
if [ -n "${ccs_maxRequestsPerSec}" ]; then
  echo "ccs_maxRequestsPerSec: ${ccs_maxRequestsPerSec}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DCCSmaxRequestsPerSec=${ccs_maxRequestsPerSec}"
fi

# CCS max concurrent requests
if [ -n "${ccs_maxConcurRequests}" ]; then
  echo "ccs_maxConcurRequests: ${ccs_maxConcurRequests}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DCCSmaxConcurRequests=${ccs_maxConcurRequests}"
fi

# CCS Block IP Address access
if [ -n "${ccs_blockIPAccess}" ]; then
  echo "ccs_blockIPAccess: ${ccs_blockIPAccess}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DCCSblockIPAccess=${ccs_blockIPAccess}"
fi

# basicAuth
if [ -n "${basicAuth}" ]; then
  echo "basicAuth: ${basicAuth}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DbasicAuth=${basicAuth}"
fi

# bearerAuth and debugProfileServiceBaseURI
if [ -n "${bearerAuth}" ]; then
  echo "bearerAuth: ${bearerAuth}"
  echo "debugProfileServiceBaseURI: ${debugProfileServiceBaseURI}"
  OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DbearerAuth=${bearerAuth} -DdebugProfileServiceBaseURI=${debugProfileServiceBaseURI}"
fi

# at least one of [basicAuth] or [bearerAuth] must be specified
if [ "${basicAuth}" != "true" ] && [ "${bearerAuth}" != "true" ]; then
  echo "No authentication mode(s) have been specified. Add 'basicAuth=true' and/or 'bearerAuth=true' in $EQARMTD_ENVFILE"
  exit 1
fi

# if 'bearerAuth' has been specified, then 'debugProfileServiceBaseURI' must also be specified
if [ "${bearerAuth}" = "true" ] && [ -z "${debugProfileServiceBaseURI}" ]; then
  echo "'bearerAuth=true' has been specified, but 'debugProfileServiceBaseURI' is missing in $EQARMTD_ENVFILE"
  exit 1
fi

# -----------------------------------------------------------------------------------------------------
# Determine the userid that is running this process
# -----------------------------------------------------------------------------------------------------
userid=$(id -un)


# -----------------------------------------------------------------------------------------------------
# Construct a unique location for working files based on $EQARMTD_WRK_DIR, userid and RDS version
# -----------------------------------------------------------------------------------------------------
EQARMTD_WRK_DIR_EXTENDED=$EQARMTD_WRK_DIR/$userid/EQARDS/$_BUILD_VERSION
OPENJ9_JAVA_OPTIONS="$OPENJ9_JAVA_OPTIONS -DEQARMTD_WRK_DIR_EXTENDED=$EQARMTD_WRK_DIR_EXTENDED"


# -----------------------------------------------------------------------------------------------------
# Construct Java system properties that should not be directly altered by the installation configuration file
# -----------------------------------------------------------------------------------------------------
MANDATORY_SYSTEM_PROPERTIES=""
MANDATORY_SYSTEM_PROPERTIES="$MANDATORY_SYSTEM_PROPERTIES\
 -Dosgi.requiredJavaVersion=17\
 -Dosgi.parentClassloader=ext"


# -----------------------------------------------------------------------------------------------------
# Merge the mandatory system properties with all the others in $OPENJ9_JAVA_OPTIONS
# -----------------------------------------------------------------------------------------------------
export OPENJ9_JAVA_OPTIONS="$MANDATORY_SYSTEM_PROPERTIES $OPENJ9_JAVA_OPTIONS"


# -----------------------------------------------------------------------------------------------------
# Construct command line options that should not be directly altered by the installation configuration file
# -----------------------------------------------------------------------------------------------------
MANDATORY_CMDLINE_OPTIONS=""
MANDATORY_CMDLINE_OPTIONS="-DrdsBuildVersion=$_EQARMTD_SCRIPT_PATH/../version.properties"
MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -Dfile.encoding=UTF-8"
MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -jar $EQARMTD_BASE/../plugins/$_launcher"
MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -user $EQARMTD_WRK_DIR_EXTENDED/user -configuration $EQARMTD_WRK_DIR_EXTENDED/configuration"

if [[ $* != *"-shutdown="* ]]; then
	MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -data $EQARMTD_WRK_DIR_EXTENDED/workspace"
else
	MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -data $EQARMTD_WRK_DIR_EXTENDED/shutdownWorkspace"	
fi	

if [[ $* != *"-shutdown="* ]]; then	
	# tracing and logDir options
	if [ "${trace}" = "true" ] || [ "${trace}" = "TRUE" ]; then
		MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -logDir=${eqarmtd_logdir}"
		MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -trace=true"
	fi
	if [ "${detailedTrace}" = "true" ] || [ "${detailedTrace}" = "TRUE" ]; then
		if [ ! -f "${detailedTraceOptions}" ]; then
		  detailedTraceOptions="${EQARMTD_BASE}/trace.options"
		fi
		MANDATORY_CMDLINE_OPTIONS="$MANDATORY_CMDLINE_OPTIONS -debug ${detailedTraceOptions}"
	fi
fi

# -----------------------------------------------------------------------------------------------------
# Combine all the various command line options together. 
#   $MANDATORY_CMDLINE_OPTIONS contains the basic launcher and Eclipse options
#   $UNSECURE_ARGS and $SECURE_ARGS contain the port options
#   $ADDITIONAL_CMDLINE_OPTS may be specified in the config file for arbitrary user supplied options
# -----------------------------------------------------------------------------------------------------
if [[ $* == *"-shutdown="* ]]; then
	CMDLINE_OPTS="${MANDATORY_CMDLINE_OPTIONS}"
else
	CMDLINE_OPTS="${MANDATORY_CMDLINE_OPTIONS} ${UNSECURE_ARGS} ${SECURE_ARGS} ${ADDITIONAL_CMDLINE_OPTS} ${CC_ARGS}"
fi

# -----------------------------------------------------------------------------------------------------
# Set the umask so that all newly created files/directory have the appropriate permissions
# -----------------------------------------------------------------------------------------------------
if [ -z "${umask}" ]; then
        umask="u+rwx,go=rx"
fi
umask ${umask}

export LIBPATH="$EQARMTD_BASE/../lib:$LIBPATH"
export CLASSPATH="$EQARMTD_BASE/../plugins:$CLASSPATH:$JAVA_HOME/lib/ext"
echo -----------------------------------------------------------------------------------------------------
echo "$JAVA_HOME/bin/java ${CMDLINE_OPTS} $*"
exec $JAVA_HOME/bin/java ${CMDLINE_OPTS} $*

