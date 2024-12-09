#TODO: Add builder stage here to build the app with shinylive

FROM busybox:1.35

# Create a non-root user to own the files and run our server
RUN adduser -D static
USER static
WORKDIR /home/static

# Copy the static website using multi-stage build semantics
COPY /site .
# COPY --from=0 /app/dist .

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]