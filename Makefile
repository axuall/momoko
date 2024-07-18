.PHONY: all test tcproxy start_docker run_test stop_docker clean

all:

test: tcproxy start_docker run_test stop_docker

tcproxy:
	$(MAKE) -C tcproxy

start_docker: stop_docker
	docker run -d --name momoko_test_pg -e "POSTGRES_PASSWORD=password" -p "127.0.0.1:5432:5432" postgres -c 'max_connections=20000'
	until pg_isready -h 127.0.0.1 -p 5432 -U postgres; do \
		sleep 1; \
		echo "Waiting for PostgreSQL..."; \
	done

run_test:
	pytest tests.py

stop_docker:
	-docker rm -f momoko_test_pg 

clean: stop_docker
