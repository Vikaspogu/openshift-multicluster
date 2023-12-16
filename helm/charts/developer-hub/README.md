
<div class="pf-c-alert pf-m-warning pf-m-inline pf-u-mb-lg">
  <div class="pf-c-alert__icon">
    <i class="fas fa-fw fa-exclamation-triangle"></i>
  </div>
  <p class="pf-c-alert__title">
    <span class="pf-screen-reader">Developer preview:</span>
    This product is available as a <b>Developer Preview</b> release. To complete installation, you must sign up for a <a href="https://developers.redhat.com/products/developer-hub">Red Hat Developer Hub subscription</a>
  </p>
</div>

Red Hat Developer Hub is an enterprise-grade, open developer platform for building developer portals, containing a supported and opinionated framework. Boosting the engineering team's productivity and increasing the competitive advantages, the Red Hat Developer Hub helps reduce frustration in the engineering team.

## Dependencies

The helm chart packages the following subcharts. Their respective values can be available under the subchart name key in Helm values.

| Repository | Name | Version |
|------------|------|---------|
| https://backstage.github.io/charts | upstream(backstage) | 1.8.0 |
| https://charts.bitnami.com/bitnami | common | 2.13.3 |

## Installation

**Prerequisites**

The helm chart deploys Red Hat Developer Hub and includes the following prerequisites:

- You have a [Developer Sandbox subscription](https://developers.redhat.com/developer-sandbox) or a [Red Hat Developer Hub subscription](https://developers.redhat.com/products/developer-hub)
- Kubernetes 1.19 or later is installed.
- Helm 3.2.0 or later is installed.
- `PersistentVolume` provisioner support in the underlying infrastructure is available.

**Procedure**

Before proceeding to install the chart, download a Quay.io `pullSecret` associated with your [Red Hat Developer Hub subscription](https://developers.redhat.com/products/developer-hub). The pull secret grants you access to the developer preview version of the Red Hat Developer Hub. Without Quay.io access, the helm chart will not install.

1. Go to [Quay.io](https://quay.io/) and log in.
2. Open **Account Settings** in the menu available on the top-right side.
3. Click *Generate Encrypted Password* and repeat your password and click *Verify*
4. Select *Kubernetes Secret* tab and view or download the secret
5. Change the secrets `.metadata.name` to `rhdh-pull-secret`
5. Log into your OpenShift/Kubernetes cluster and create the secret

### OpenShift Helm Catalog

1. Click the "Create" button at the top of the modal dialog on this page
2. Update host settings, so Backstage can create proper connection between its frontend and backend:
    - If you plan to use the default OpenShift router, please update:

        ```yaml
        global:
          clusterRouterBase: apps.example.com
        ```

    - If you want to host Red Hat Developer Hub on a custom host or if you are not using OpenShift, please update:

        ```yaml
        global:
          host: backstage.example.com
        ```

    - If you are not using OpenShift, please instruct the chart not to deploy `Route` resource and use `Ingress` instead:

        ```yaml
        route:
          enabled: false
        upstream:
          ingress:
            enabled: true
        ```

3. Update your storage preference. If you do not want persistent storage attached to the deployed database, please update:

    ```yaml
    upstream:
      postgresql:
        primary:
          persistence:
            enabled: false
    ```

### Manual installation from the Chart Repository

1. Add the chart repository using the following command:

    ```console
    helm repo add openshift-helm-charts https://charts.openshift.io/
    ```

2. Download the default values and review them:

    ```console
    helm show values openshift-helm-charts/redhat-developer-hub > values.yaml
    ```

3. Perform the **required** value changes mentioned in the section [OpenShift Helm Catalog](#openshift-helm-catalog) above in steps **2** and **3**.
4. Install the chart:

    ```console
    helm upgrade -i <release_name> -f values.yaml openshift-helm-charts/redhat-developer-hub
    ```

### Uninstalling the Chart

To uninstall/delete the `<release_name>` helm release manually, run:

```console
helm uninstall <release_name>
```

## Values

| Key | Description | Type | Default |
|-----|-------------|------|---------|
| global.auth | Enable service authentication within Backstage instance | object | `{"backend":{"enabled":true,"existingSecret":"","value":""}}` |
| global.auth.backend | Backend service to service authentication <br /> Ref: https://backstage.io/docs/auth/service-to-service-auth/ | object | `{"enabled":true,"existingSecret":"","value":""}` |
| global.auth.backend.enabled | Enable backend service to service authentication, unless configured otherwise it generates a secret value | bool | `true` |
| global.auth.backend.existingSecret | Instead of generating a secret value, refer to existing secret | string | `""` |
| global.auth.backend.value | Instead of generating a secret value, use fo;lowing value | string | `""` |
| global.clusterRouterBase | Shorthand for users who do not want to specify a custom HOSTNAME. Used ONLY with the DEFAULT upstream.backstage.appConfig value and with OCP Route enabled. | string | `"apps.example.com"` |
| global.dynamic.includes | Array of YAML files listing dynamic plugins to include with those listed in the `plugins` field. Relative paths are resolved from the working directory of the initContainer that will install the plugins (`/opt/app-root/src`). | list | `["dynamic-plugins.default.yaml"]` |
| global.dynamic.includes[0] | List of dynamic plugins included inside the `janus-idp/backstage-showcase` container image, some of which are disabled by default. This file ONLY works with the `janus-idp/backstage-showcase` container image. | string | `"dynamic-plugins.default.yaml"` |
| global.dynamic.plugins | List of dynamic plugins, possibly overriding the plugins listed in `includes` files. Every item defines the plugin `package` as a [NPM package spec](https://docs.npmjs.com/cli/v10/using-npm/package-spec), an optional `pluginConfig` with plugin-specific backstage configuration, and an optional `disabled` flag to disable/enable a plugin listed in `includes` files. It also includes an `integrity` field that is used to verify the plugin package [integrity](https://w3c.github.io/webappsec-subresource-integrity/#integrity-metadata-description). | list | `[]` |
| global.host | Custom hostname shorthand, overrides `global.clusterRouterBase`, `upstream.ingress.host`, `route.host`, and url values in `upstream.backstage.appConfig` | string | `""` |
| route | OpenShift Route parameters | object | `{"annotations":{},"enabled":true,"host":"{{ .Values.global.host }}","path":"/","tls":{"caCertificate":"","certificate":"","destinationCACertificate":"","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"","termination":"edge"},"wildcardPolicy":"None"}` |
| route.annotations | Route specific annotations | object | `{}` |
| route.enabled | Enable the creation of the route resource | bool | `true` |
| route.host | Set the host attribute to a custom value. If not set, OpenShift will generate it, please make sure to match your baseUrl | string | `"{{ .Values.global.host }}"` |
| route.path | Path that the router watches for, to route traffic for to the service. | string | `"/"` |
| route.tls | Route TLS parameters <br /> Ref: https://docs.openshift.com/container-platform/4.9/networking/routes/secured-routes.html | object | `{"caCertificate":"","certificate":"","destinationCACertificate":"","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"","termination":"edge"}` |
| route.tls.caCertificate | Cert authority certificate contents. Optional | string | `""` |
| route.tls.certificate | Certificate contents | string | `""` |
| route.tls.destinationCACertificate | Contents of the ca certificate of the final destination. <br /> When using reencrypt termination this file should be provided in order to have routers use it for health checks on the secure connection. If this field is not specified, the router may provide its own destination CA and perform hostname validation using the short service name (service.namespace.svc), which allows infrastructure generated certificates to automatically verify. | string | `""` |
| route.tls.enabled | Enable TLS configuration for the host defined at `route.host` parameter | bool | `true` |
| route.tls.insecureEdgeTerminationPolicy | Indicates the desired behavior for insecure connections to a route. <br /> While each router may make its own decisions on which ports to expose, this is normally port 80. The only valid values are None, Redirect, or empty for disabled. | string | `"Redirect"` |
| route.tls.key | Key file contents | string | `""` |
| route.tls.termination | Specify TLS termination. | string | `"edge"` |
| route.wildcardPolicy | Wildcard policy if any for the route. Currently only 'Subdomain' or 'None' is allowed. | string | `"None"` |
| upstream | Upstream Backstage [chart configuration](https://github.com/backstage/charts/blob/main/charts/backstage/values.yaml) | object | Use Openshift compatible settings |
| upstream.backstage.extraVolumes[0] | Ephemeral volume that will contain the dynamic plugins installed by the initContainer below at start. | object | `{"ephemeral":{"volumeClaimTemplate":{"spec":{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"1Gi"}}}}},"name":"dynamic-plugins-root"}` |
| upstream.backstage.extraVolumes[0].ephemeral.volumeClaimTemplate.spec.resources.requests.storage | Size of the volume that will contain the dynamic plugins. It should be large enough to contain all the plugins. | string | `"1Gi"` |
| upstream.backstage.initContainers[0].image | Image used by the initContainer to install dynamic plugins into the `dynamic-plugins-root` volume mount. It could be replaced by a custom image based on this one. | string | `quay.io/janus-idp/backstage-showcase:latest` |

## Opinionated Backstage deployment

This chart defaults to an opinionated deployment of Backstage that provides user with a usable Backstage instance out of the box.

Features enabled by the default chart configuration:

1. Uses **Red Hat Developer Hub** image that pre-loads a lot of useful plugins and features
2. Exposes a `Route` for easy access to the instance
3. Enables OpenShift-compatible PostgreSQL database storage

For additional instance features please consuls **Red Hat Developer Hub documentation**.

Additional features can be enabled by extending the default configuration at:

```yaml
upstream:
  backstage:
    appConfig:
      # Inline app-config.yaml for the instance
    extraEnvVars:
      # Additional environment variables
```

## Features

Red Hat Developer Hub is an opinionated deployment of [Backstage](https://backstage.io/) that provides user with a usable instance out of the box.

Features enabled by the default chart configuration:

1. Uses **Red Hat Developer Hub** image that pre-loads a lot of useful plugins and features
2. Exposes a `Route` for easy access to the instance. Alternatively, allows you to expose an `Ingress` resource for non-OpenShift deployments.
3. Enables OpenShift-certified PostgreSQL database storage.

For additional instance features, see [Red Hat Developer Hub documentation](https://developers.redhat.com/products/developer-hub).
