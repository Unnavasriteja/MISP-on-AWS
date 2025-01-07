# Base MISP image
FROM harvarditsecurity/misp:latest

# Set environment variables (replace these with actual values or reference from a .env file)
ENV MYSQL_HOST=your-rds-endpoint.amazonaws.com \
    MYSQL_PORT=3306 \
    MYSQL_DATABASE=mispdb \
    MYSQL_USER=admin \
    MYSQL_PASSWORD=YourStrongPassword123 \
    REDIS_HOST=your-redis-endpoint.amazonaws.com \
    REDIS_PORT=6379

# Expose necessary ports
EXPOSE 80 443

# Copy custom entrypoint script if needed (Optional)
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

# Start MISP
CMD ["/init"]
