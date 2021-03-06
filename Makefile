.PHONY: build build-v1 clean deploy

V1_YAML = v1/html/static/reach-openapi-v1.yaml

V1_SRC = v1/source

deploy: build
	@echo Pushing new build
	@git add .
	@git diff --quiet --exit-code --cached || git commit -m "build docs"
	@git push git@github.com:reach-service/docs-api.git `git rev-parse --abbrev-ref HEAD`

build: build-v1

build-v1: .npminstall
	@echo Building reach openapi yaml for v1

	@cat $(V1_SRC)/introduction.yaml > $(V1_YAML)
	@cat $(V1_SRC)/chat/conversations.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/chat/messages.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/chat/users.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/chat/subjects.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/subject/events.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/subject/subjects.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/subject/users.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/subject/conversations.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/inbox/events.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/notify/bindings.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/auth/authentication.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/iam/users.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/iam/conversations.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/iam/subjects.yaml >> $(V1_YAML)

	@cat $(V1_SRC)/account/users.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/account/personas.yaml >> $(V1_YAML)

	# Compile all definitions files
	@cat $(V1_SRC)/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/chat/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/subject/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/inbox/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/notify/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/auth/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/iam/definitions.yaml >> $(V1_YAML)
	@cat $(V1_SRC)/account/definitions.yaml >> $(V1_YAML)

	@node_modules/swagger-cli/bin/swagger-cli.js validate $(V1_YAML)

	@echo Complete

.npminstall:
	@echo Getting dependencies using npm

	npm install swagger-cli
	touch $@

clean:
	@echo Cleaning
	rm -f .npminstall

serve:
	@node index.js
