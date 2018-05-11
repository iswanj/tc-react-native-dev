# Pull base image.
FROM iswanj/tc-react-native:latest

# install python dev
RUN apt-get update -y && apt-get install python-dev libssl-dev autoconf automake libtool -y
RUN apt-get install --reinstall make -y
# Install watchman
RUN git clone https://github.com/facebook/watchman.git
RUN cd watchman && git checkout v4.7.0 && ./autogen.sh && ./configure && make && make install
RUN rm -rf watchman


# Default react-native web server port
EXPOSE 8081


# User creation
ENV USERNAME dev

RUN adduser --disabled-password --gecos '' $USERNAME


# Add Tini
ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

USER $USERNAME

# Set workdir
# You'll need to run this image with a volume mapped to /home/dev/ (i.e. -v $(pwd):/home/dev) or override this value
WORKDIR /home/$USERNAME/app

# Tell gradle to store dependencies in a sub directory of the android project
# this persists the dependencies between builds
ENV GRADLE_USER_HOME /home/$USERNAME/app/android/gradle_deps

ENTRYPOINT ["/tini", "--"]
