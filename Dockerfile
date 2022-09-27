# This will be a multi stage build dockerfile. First we will build an npm app using node:alpine base image,
# then the resulting build files are put into another container with nginx as base image for serving in production

FROM node:16-alpine AS builder
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
EXPOSE 80
# Expose does not do anything locally, expose instruction works on elastic beanstalk to map container port to vm port
COPY --from=builder /app/build /usr/share/nginx/html
# No default command needed as nginx base image has command to start nginx