FROM		debian:latest
MAINTAINER 	Jan Christian Grünhage <me@jcg.re>

RUN	export DEBIAN_FRONTEND=noninteractive \
	&& apt-get clean \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
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
		gettext \
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
	&& echo 'Yes, do as I say!' | apt-get autoremove -y --force-yes \
		build-essential \
		python2.7-dev \
		libffi-dev \
                libssl-dev\
                libjpeg-dev \
                libxslt1-dev \
                libpq-dev \
                libldap2-dev \
                libsasl2-dev \
                git \
		gnupg \
		cpp \ 
		g++ \
		gcc \
		gettext \
		python3.4-minimal \
		systemd \
		adduser \
		perl \
	&& rm -rf /tmp \
	&& rm -rf /var/lib/apt/* /var/cache/apt/* 
	

ADD	root /
VOLUME	/data
EXPOSE	8448 8008

ENTRYPOINT	["/usr/local/bin/run.sh"]
CMD		["start"]

