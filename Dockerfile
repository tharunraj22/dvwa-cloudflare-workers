# Start from the base DVWA image
FROM vulnerables/web-dvwa:latest

# Copy our custom startup script into the container
COPY start.sh /start.sh

# Make sure it is executable
RUN chmod +x /start.sh

# Override the default background behavior
ENTRYPOINT ["/start.sh"]