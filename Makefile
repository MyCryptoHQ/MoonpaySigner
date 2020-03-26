.PHONY: fmt build clean deploy

fmt:
	go fmt
	cd terraform/ && terraform fmt -diff -recursive
build:
	env GOOS=linux go build -ldflags="-s -w" -o bin/moonpaysigner main.go
clean:
	rm -rf ./bin ./vendor Gopkg.lock
deploy: fmt clean build
	zip -r moonpaysigner.zip 'bin/moonpaysigner'