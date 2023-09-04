FROM quay.io/keycloak/keycloak:22.0 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:22.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Add keycloak-gsis-providers
ADD --chown=keycloak:keycloak https://github.com/cti-nts/keycloak-gsis-providers/releases/download/v2.0.0/keycloak-gsis-providers-java-17-v2.0.0.jar /opt/keycloak/providers/keycloak-gsis-providers-java-17-v2.0.0.jar

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]