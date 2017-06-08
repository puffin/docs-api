.PHONY: build build-v1 clean deploy

V1_YAML = v1/html/static/reach-openapi-v1.yaml

V1_SRC = v1/source

deploy: build
	@echo Pushing to production
	@git add .
	@git diff --quiet --exit-code --cached || git commit -m "build docs"
	@git push git@github.com:reach-service/docs-api.git master

build: build-v1

build-v1: .npminstall
	@echo Building reach openapi yaml for v1

	@cat $(V1_SRC)/introduction.yaml > $(V1_YAML)
	@cat $(V1_SRC)/chat/messages.yaml >> $(V1_YAML)
	
	@cat $(V1_SRC)/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/chat/definitions.yaml >> $(V1_YAML)

	@node_modules/swagger-cli/bin/swagger.js validate $(V1_YAML)

	@echo Complete

.npminstall:
	@echo Getting dependencies using npm

	npm install swagger-cli
	touch $@

clean:
	@echo Cleaning
	rm -f .npminstall
