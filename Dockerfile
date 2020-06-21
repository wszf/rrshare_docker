#本镜像基于最新版alpine+glibc+rrshareweb
FROM alpine:20200621

LABEL MAINTAINER="azure <https://baiyue.one>"


# 配置glibc
ENV GLIBC_VERSION=2.29-r0

RUN apk update \
	&& apk --no-cache add wget libstdc++ tzdata \
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo 'Asia/Shanghai' >  /etc/timezone \
	&& wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
	&& wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
	&& wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
 	&& apk --no-cache add glibc-${GLIBC_VERSION}.apk \
	&& apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
	&& mkdir -p /rrshare \
	&& mkdir -p /opt/work/store \    
	&& wget -q http://appdown.rrys.tv/rrshareweb_linux.tar.gz -O /rrshare/rrshareweb_linux.tar.gz \
	&& tar zxvf /rrshare/rrshareweb_linux.tar.gz -C /rrshare/ \     
	&& rm -rf /rrshare/rrshareweb_linux.tar.gz \   
	&& apk del wget tzdata \
	&& rm -rf /glibc-${GLIBC_VERSION}.apk \
	&& rm -rf /glibc-bin-${GLIBC_VERSION}.apk

WORKDIR /
VOLUME ["/opt/work/store"]
EXPOSE 3001 

CMD ["sh", "-c", "/rrshare/rrshareweb/rrshareweb"]
