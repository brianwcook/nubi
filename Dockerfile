FROM registry.access.redhat.com/ubi8/ubi AS builder

RUN mkdir -p /mnt/rootfs

RUN \
    dnf install --installroot /mnt/rootfs \
        bash \
        coreutils-single \
        coreutils-single \
        crypto-policies-scripts \
        dnf-plugin-subscription-manager \
        findutils \
        gdb-gdbserver \
        glibc-minimal-langpack \
        glibc-minimal-langpack \
        gzip \
        langpacks-en \
        redhat-release \
        rootfiles \
        subscription-manager \
        tar \
        vim-minimal \
        yum \
        --releasever 8 --setopt install_weak_deps=false --nodocs -y; \
    dnf --installroot /mnt/rootfs clean all

RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

FROM scratch
LABEL maintainer="Red Hat, Inc."LABEL com.redhat.component="ubi8-container"
LABEL name="ubi8/ubi"
LABEL version="8.5"
#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
#labels for container catalog
LABEL summary="ubi8 image"
LABEL description="This is an image."
LABEL io.k8s.display-name="Ubi8"
LABEL io.openshift.expose-services=""

COPY --from=builder /mnt/rootfs/ /
RUN rm -rf /etc/yum.repos.d/*.repo
COPY --from=builder /etc/yum.repos.d/ubi.repo /etc/yum.repos.d/ubi.repo
CMD /bin/bash
