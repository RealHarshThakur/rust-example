# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG APP_NAME=rust-todo
#############################
# Create a stage for building the application.

FROM ttl.sh/rust-base:dev-7h@sha256:4da36557b97b49098d29d5b72113ddfffa135f9e9e00c32300ac7cfb06bd91a0  AS build
RUN mkdir -p /tmp
ARG APP_NAME
WORKDIR /app


COPY . .

# Build the application.
RUN cargo build --locked --release && \
cp ./target/release/$APP_NAME /bin/todo

################################################################################
# Create a new stage for running the application that contains the minimal
# runtime dependencies for the application. This often uses a different base
# image from the build stage where the necessary files are copied from the build
# stage.

FROM ttl.sh/rust-base:19h@sha256:3834849608901a455c808b70607df6f32e898b38d784551d0b9bb6e1b14c1af6 AS final

# Copy the executable from the "build" stage.
COPY --from=build /bin/todo /bin/


# What the container should run when it is started.
CMD ["/bin/todo"]
