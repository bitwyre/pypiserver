FROM python:3.8-alpine as base

# Copy the requirements & code and install them
# Do this in a separate image in a separate directory
# to not have all the build stuff in the final image
FROM base AS builder
RUN apk update
# Needed to build cffi
RUN apk add python-dev build-base libffi-dev
COPY . /code
RUN mkdir /install
RUN pip install --no-warn-script-location \
    --prefix=/install \
    /code --requirement /code/docker-requirements.txt

FROM base

# Copy the libraries installed via pip
COPY --from=builder /install /usr/local
WORKDIR /data
EXPOSE 8080
ENTRYPOINT ["pypi-server", "-p", "8080"]
CMD ["packages"]
