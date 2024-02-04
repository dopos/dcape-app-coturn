## dcape-app-template Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= turn

#- Docker image name
IMAGE              ?= ghcr.io/coturn/coturn

#- Docker image tag
IMAGE_VER          ?= 4.6.2-alpine

# The domain name of this homeserver.
APP_DOMAIN         ?= dev.test

# Hostname for external access
APP_SITE           ?= $(APP_DOMAIN)

#EXTERNAL_IP        ?= $(shell docker run --rm $(IMAGE):$(IMAGE_VER) detect-external-ip)

#- STATIC_AUTH_SECRET
STATIC_AUTH_SECRET ?= $(shell openssl rand -hex 16; echo)

#- CLI_SECRET
CLI_SECRET         ?= $(shell openssl rand -hex 16; echo)

#- UDP min port
MIN_PORT            = 49152
#- UDP max port
MAX_PORT            = 49200

USE_DB              = yes
DB_INIT_SQL         = schema.sql
USE_DCAPE_DC        = no
# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export

-include $(CFG)
export

DB_ADMIN_USER      ?= $(PGUSER)

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------

## Cals and show external ip
ext-ip: CMD=exec app detect-external-ip
ext-ip: dc

## Open CLI via telnet
cli:
	@echo "Use pass: $(CLI_SECRET)"
	@telnet 127.0.0.1 5766

PG_DSN := postgres://$(PGUSER):$(PGPASSWORD)@db/$(PGDATABASE)?sslmode=disable

## Add admin user
admin-add: CMD=exec app turnadmin -A -u admin -p "$(CLI_SECRET)" --psql-userdb="$(PG_DSN)"
admin-add: dc

## List admin users
admin-ls: CMD=exec app turnadmin -L --psql-userdb="$(PG_DSN)"
admin-ls: dc
