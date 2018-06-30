# Reach API Documentation

test change

This repository holds the API reference available at http://api-docs.rea.ch.

The Reach API reference uses the [OpenAPI standard](https://openapis.org/) and the [ReDoc document generator](https://github.com/Rebilly/ReDoc).

Reach API version 1 is an active and in-progress project.

All the documentation is written in YAML and found in the v1/source directories.

* When adding a new route, please add it to the correct service and file. For example, a chat --> messages route will go in [chat/messages.yaml](https://github.com/reach-service/docs-api/blob/master/v1/source/chat/messages.yaml).
* To add a new tag, please do so in [introduction.yaml](https://github.com/reach-service/docs-api/blob/master/v1/source/introduction.yaml)
* Definitions should be added to [definitions.yaml](https://github.com/reach-service/docs-api/blob/master/v1/source/definitions.yaml)

There is no strict style guide but please try to follow the example of the existing documentation.

## Usage

To build the full YAML, run `make build` and it will be output to `html/static/reach-openapi.yaml`. This will also check syntax using [swagger-cli](https://github.com/BigstickCarpet/swagger-cli).

## Deploy changes

Whenever you make changes to the documentation and want to deploy it in production, you can execute the `$ make deploy`command.

The documentation is available online here: http://api-docs.rea.ch.
