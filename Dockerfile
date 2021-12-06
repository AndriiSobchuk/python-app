FROM python:3.7-alpine3.14
COPY ./application /home/python-user
WORKDIR /home/python-user/

RUN adduser -s /bin/sh -h /home/python-user -D python-user && \
    pip3 install --no-cache-dir aiohttp multidict==4.5.2 yarl==1.3.0 && \
    python3 setup.py install

USER python-user
ENV PATH="/home/python-user/.local/bin:$PATH"
EXPOSE 8080 
CMD ["python3", "-m", "demo"]
