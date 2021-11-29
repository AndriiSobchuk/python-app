FROM python:3.7-alpine3.14
COPY ~/python-app/application /home/python-user
WORKDIR /home/python-user

RUN adduser -s /bin/sh -h /home/python-user -D python-user && \
    pip3 install --no-cache-dir aiohttp multidict==4.5.2 yarl==1.3.0 && \
    python3 setup.py install

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz


USER python-user
ENV PATH="/home/python-user/.local/bin:$PATH"
EXPOSE 8080 
CMD ["python3", "-m", "demo"]
