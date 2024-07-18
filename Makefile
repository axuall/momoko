include .testenv

.PHONY: all test tcproxy start_docker run_test stop_docker clean

all:

test: tcproxy start_docker run_test stop_docker

tcproxy:
	$(MAKE) -C tcproxy

start_docker: stop_docker
	docker run -d --name ${CONTAINER_NAME} -e POSTGRES_MAX_CONNECTIONS=20000  -e "POSTGRES_PASSWORD=${MOMOKO_TEST_PASSWORD}" -p "${MOMOKO_TEST_HOST}:${MOMOKO_TEST_PORT}:5432" postgres -c 'max_connections=20000'
	until pg_isready -h ${MOMOKO_TEST_HOST} -p ${MOMOKO_TEST_PORT} -U ${MOMOKO_TEST_USER}; do \
		sleep 1; \
		echo "Waiting for PostgreSQL..."; \
	done

run_test:
	pytest

stop_docker:
	-docker rm -f ${CONTAINER_NAME}

clean: stop_docker
