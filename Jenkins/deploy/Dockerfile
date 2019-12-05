# DOCKERFILE
# 基础镜像
FROM harbor.scnebula.com/base/jre1.8:vIMAGE_VERSION
LABEL maintainer="nestor <niu8753@163.com>" model="APP_NAME"
# 拷贝发布文件到容器（./pangu-gate-server/target/pangu-gate.jar）
COPY SOURCE_APP_FILE.jar /app.jar
# 对外端口
expose APP_PORT
# 运行命令
# ENTRYPOINT ["java" ,"-jar","/app.jar"]
