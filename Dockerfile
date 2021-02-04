FROM buildroot/base:latest

ARG BUILDROOT_VERSION

COPY scripts/ ${HOME}/scripts/

ENV PATH=${PATH}:${HOME}/scripts
ENV ARTIFACTS=${HOME}/artifacts

# Downloading and extracting buildroot
RUN wget -q -c https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz && \
tar axf buildroot-${BUILDROOT_VERSION}.tar.gz && mv buildroot-${BUILDROOT_VERSION} buildroot &&\
rm *.tar.gz && mkdir $ARTIFACTS && chmod 777 $ARTIFACTS

WORKDIR ${HOME}/buildroot

ENTRYPOINT [ "start-build.sh" ]
