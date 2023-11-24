ARG KEYCLOAK_VERSION=21.0.1
ARG GSIS_PROVIDERS_VERSION=2.0.0

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

# Add keycloak-gsis-providers
ARG GSIS_PROVIDERS_VERSION
ADD --chown=keycloak:keycloak https://github.com/cti-nts/keycloak-gsis-providers/releases/download/v${GSIS_PROVIDERS_VERSION}/keycloak-gsis-providers-java-11-v${GSIS_PROVIDERS_VERSION}.jar /opt/keycloak/providers/keycloak-gsis-providers-${GSIS_PROVIDERS_VERSION}.jar

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

ARG KEYCLOAK_VERSION
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENTRYPOINT [ "/opt/keycloak/bin/kc.sh", "start-dev", "--features=preview" ]