# Build Stage

FROM node:26-alpine3.23 AS builder

WORKDIR /app

COPY package*.json .

RUN npm install 

COPY . .

RUN npm run build
######################
FROM nginx:1.31.3

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]



