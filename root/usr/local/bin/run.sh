#!/usr/bin/env bash

COMMAND="${1}"

prepare() {
	chown -R ${UID}:${GID} /data
	cd /synapse
	source bin/activate
}

case ${COMMAND} in
	"start")
		prepare
		su-exec ${UID}:${GID} python2 -m synapse.app.homeserver \
			--config-path /data/config/homeserver.yaml
		;;
	"generate")
                breakup="0"
                [[ -z "${SERVER_NAME}" ]] && echo "STOP! environment variable SERVER_NAME must be set" && breakup="1"
                [[ -z "${REPORT_STATS}" ]] && echo "STOP! environment variable REPORT_STATS must be set to 'no' or 'yes'" && breakup="1"
                [[ "${REPORT_STATS}" != "yes" ]] && [[ "${REPORT_STATS}" != "no" ]] && \
                        echo "STOP! REPORT_STATS needs to be 'no' or 'yes'" && breakup="1"
                [[ "${breakup}" == "1" ]] && exit 1
                prepare
                su-exec ${UID}:${GID} python2 -m synapse.app.homeserver \
                        -c /data/config/homeserver.yaml.tmp \
                        --generate-config \
                        -H ${SERVER_NAME} \
                        --report-stats ${REPORT_STATS}

		mkdir -p /data/database
		touch /data/database/homeserver.db
                sed 's#/synapse/homeserver.db#/data/database/homeserver.db#; 
			s#/synapse/homeserver.log#/data/log/homeserver.log#; 
			s#/synapse/media_store#/data/media_store#; 
			s#/synapse/uploads#/data/uploads#' /data/config/homeserver.yaml.tmp > /data/config/homeserver.yaml

                ;;
esac
