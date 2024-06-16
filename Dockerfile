FROM eclipse-temurin:22-jdk-alpine

MAINTAINER rl <robin@synt3x.com>

ENV VERSION=latest \
	XMX=2G \
	XMS=256M \
	EULA=0 \
	ARGS="" 

WORKDIR /minecraft

COPY mc_run.sh /mc_run.sh
RUN chmod +x /mc_run.sh

RUN apk update
RUN apk --no-cache add git wget

EXPOSE 25565
EXPOSE 25566

VOLUME ["/minecraft"]

CMD ["/mc_run.sh"]
