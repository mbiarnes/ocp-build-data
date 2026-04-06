# This is a base image for supporting running nodejs to build an app (console does this).
# The same Dockerfile should serve for most versions of nodejs.
FROM nodejs
# rhel-7 based:
#   rhscl/nodejs-8-rhel7 from rh-nodejs8-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=67373)
#   rhscl/nodejs-12-rhel7 from rh-nodejs12-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=72290)
# rhel-8 based:
#   ubi8/nodejs-12 from nodejs-12-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=72249)
#   ubi8/nodejs-14 from nodejs-14-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=74670)
#
# rhel-8 repos include potential updates to nodejs patch version, but we must
# lock the version to match the headers tarball required for compilation, so we
# exclude upgrades for nodejs below.

USER root
RUN echo 'skip_missing_names_on_install=0' >> /etc/yum.conf \
 && echo 'exclude=nodejs nodejs-docs nodejs-full-i18n nodejs-libs' >> /etc/yum.conf \
 && yum update -y  \
 && yum clean all

# Upgrade npm to 10.8.1 for cachi2 hermetic build support
# npm 10.8.1+ properly handles offline dependency resolution
RUN npm install -g npm@10.8.1

USER 1001
