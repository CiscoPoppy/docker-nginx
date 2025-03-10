FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy website files from your repo to the nginx html directory
COPY website/ /usr/share/nginx/html/

# Copy custom nginx config to change port to 8088
RUN echo 'server {\n\
    listen 8088;\n\
    server_name localhost;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# Expose port 8088
EXPOSE 8088

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
