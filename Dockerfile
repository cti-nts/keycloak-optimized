ARG KEYCLOAK_VERSION=20.0.5
ARG GSIS_PROVIDERS_VERSION=2.0.0

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

# Add keycloak-gsis-providers
ARG GSIS_PROVIDERS_VERSION
ADD --chown=keycloak:keycloak https://github.com/cti-nts/keycloak-gsis-providers/releases/download/v${GSIS_PROVIDERS_VERSION}/keycloak-gsis-providers-java-11-v${GSIS_PROVIDERS_VERSION}.jar /opt/keycloak/providers/keycloak-gsis-providers-${GSIS_PROVIDERS_VERSION}.jar

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

ARG KEYCLOAK_VERSION
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]