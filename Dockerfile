FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/cluster-authentication-operator
COPY . .
RUN ADDITIONAL_GOTAGS="ocp" go build -o authentication-operator ./cmd/authentication-operator

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-authentication-operator/authentication-operator /usr/bin/
COPY manifests /manifests
ENTRYPOINT ["/usr/bin/authentication-operator"]
LABEL io.k8s.display-name="OpenShift cluster-authentication-operator" \
      io.k8s.description="This is a component of OpenShift and manages cluster authentication settings" \
      com.redhat.component="cluster-authentication-operator" \
      maintainer="OpenShift Auth Team <aos-auth-team@redhat.com>" \
      name="openshift/ose-cluster-authentication-operator" \
      version="v4.0.0" \
      io.openshift.tags="openshift" \
      io.openshift.release.operator=true
