FROM nginx
WORKDIR /app
COPY . /usr/share/nginx/html/index.html
