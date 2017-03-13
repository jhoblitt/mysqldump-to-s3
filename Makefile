all: build

build:
	docker build -t lsstsqre/mysqldump_to_s3:latest .
	@echo "Successfully built mysqldump_to_s3"
