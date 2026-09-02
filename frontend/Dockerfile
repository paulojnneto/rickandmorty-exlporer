FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .
ARG BACKEND_URL=http://localhost:3000
RUN flutter build web --release --dart-define=BACKEND_URL=${BACKEND_URL}

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
