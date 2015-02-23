#!/bin/bash
set -ex

groupadd -r voms
useradd voms -g voms

ls -l /code

tar -C / -xvzf /code/voms-admin-server/target/voms-admin-server.tar.gz

chown -R voms:voms /var/lib/voms-admin/work /var/log/voms-admin

sed -i -e "s#localhost#dev.local.io#g" /etc/voms-admin/voms-admin-server.properties

# Do this or voms-admin webapp will fail silently and always return 503
mkdir /etc/grid-security/vomsdir

if [ -z "$DB_PORT_3306_TCP_ADDR" ]; then
  echo "This container requires a linked container hosting the VOMS MySQL database. The container alias must be called 'db'"
  exit 1
fi

# Wait for database service to be up
mysql_host=$DB_PORT_3306_TCP_ADDR
mysql_port=$DB_PORT_3306_TCP_PORT

echo -n "waiting for TCP connection to $mysql_host:$mysql_port..."

while ! nc -w 1 $mysql_host $mysql_port 2>/dev/null
do
  echo -n .
  sleep 1
done

echo 'ok'

# Configure the VO
if [ -z "$VOMS_SKIP_CONFIGURE" ]; then
  voms-configure install \
    --vo test \
    --dbtype mysql \
    --skip-voms-core \
    --deploy-database \
    --dbname $VOMS_DB_NAME \
    --dbusername $VOMS_DB_USERNAME \
    --dbpassword $VOMS_DB_PASSWORD \
    --dbhost db \
    --mail-from $VOMS_MAIL_FROM \
    --smtp-host mail
fi

# Setup loggin so that everything goes to stdout
cp /logback.xml /etc/voms-admin/voms-admin-server.logback
cp /logback.xml /etc/voms-admin/test/logback.xml
chown voms:voms /etc/voms-admin/voms-admin-server.logback /etc/voms-admin/test/logback.xml

# Deploy test vo
touch '/var/lib/voms-admin/vo.d/test'

# Set log levels
VOMS_LOG_LEVEL=${VOMS_LOG_LEVEL:-INFO}
JAVA_LOG_LEVEL=${JAVA_LOG_LEVEL:-ERROR}

VOMS_JAVA_OPTS="-DVOMS_LOG_LEVEL=${VOMS_LOG_LEVEL} -DJAVA_LOG_LEVEL=${JAVA_LOG_LEVEL} $VOMS_JAVA_OPTS"

if [ -n "$ENABLE_JREBEL" ]; then
  #if [ ! -f "/jrebel/jrebel.jar" ]; then
    #echo "You need to mount a volume in /jrebel containing the jrebel jar and your jrebel license."
  #else
    #su voms -s /bin/bash -c "java -jar /jrebel/jrebel.jar -activate /jrebel/jrebel.license"
    #echo "JRebel license correctly activated."
    VOMS_JAVA_OPTS="-javaagent:/jrebel/jrebel.jar -Drebel.stats=false -Drebel.usage_reporting=false $VOMS_JAVA_OPTS"
fi

if [ -z "$VOMS_DEBUG_PORT" ]; then
  VOMS_DEBUG_PORT=1044
fi

if [ -z "$VOMS_DEBUG_SUSPEND" ]; then
  VOMS_DEBUG_SUSPEND="n"
fi

if [ ! -z "$VOMS_DEBUG" ]; then
  VOMS_JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=$VOMS_DEBUG_PORT,suspend=$VOMS_DEBUG_SUSPEND $VOMS_JAVA_OPTS"
fi

## Add test0 admin
voms-db-util add-admin --vo test --cert /usr/share/igi-test-ca/test0.cert.pem || echo "Error creating test0 admin. Does it already exist?"

# Start service
su voms -s /bin/bash -c "java $VOMS_JAVA_OPTS -jar /usr/share/java/voms-container.jar $VOMS_ARGS"
