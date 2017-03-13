FROM		debian:latest
MAINTAINER 	Jan Christian Grünhage <me@jcg.re>

RUN	export DEBIAN_FRONTEND=noninteractive \
	&& apt-get clean \
	&& apt update \
	&& apt upgrade -y \
	&& apt install -y \
		build-essential \
		python2.7-dev \
		libffi-dev \
		python-pip \
		python-virtualenv \
		sqlite3 \
		libssl-dev\
		libjpeg-dev \
		libxslt1-dev \
		libpq-dev \
		libldap2-dev \
		libsasl2-dev \
		git \
		bash \
	&& cd tmp \
	&& git clone https://github.com/ncopa/su-exec \
	&& cd su-exec \
	&& make \
	&& chmod 755 su-exec \
	&& cp su-exec /bin/ \
	&& mkdir /synapse \
	&& virtualenv -p python2.7 /synapse \ 
	&& . /synapse/bin/activate \
	&& pip install --upgrade pip \
	&& pip install --upgrade setuptools \
	&& pip install psycopg2 \
	&& pip install python-ldap \
	&& pip install https://github.com/matrix-org/synapse/tarball/master \
	&& pip install matrix-synapse-ldap3 \
	&& mkdir /data \
	&& apt remove -y \
		build-essential \
		python2.7-dev \
		libffi-dev \
                python-pip \
                python-virtualenv \
                libssl-dev\
                libjpeg-dev \
                libxslt1-dev \
                libpq-dev \
                libldap2-dev \
                libsasl2-dev \
                git \
	&& rm -rf /tmp \
	&& rm -rf /var/lib/apt/* /var/cache/apt/* 
	

ADD	root /
VOLUME	/data
EXPOSE	8448 8008

ENTRYPOINT	["/usr/local/bin/run.sh"]
CMD		["start"]

