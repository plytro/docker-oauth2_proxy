NAME = plytro/oauth2_proxy
VERSION = 2.2.0

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	docker run $(NAME):$(VERSION) --version

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/plytro/oauth2_proxy/trigger/07405625-6d78-40b8-ad7f-fc2278ddd477/
