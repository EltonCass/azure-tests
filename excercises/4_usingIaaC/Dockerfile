# Use an official web server image as the base image (e.g., Nginx)
FROM nginx:latest

# Copy your HTML file to the default web server directory
COPY index.html /usr/share/nginx/html

# Expose port 80 to allow incoming HTTP traffic
EXPOSE 80

# Start the web server when the container starts
CMD ["nginx", "-g", "daemon off;"]
