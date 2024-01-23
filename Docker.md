# Docker Commands

## Containerization Steps
1. Build images
2. Create containers from images

## Remove & Rebuild Container and Images
```shellscript
docker stop nginx && docker container rm nginx && docker image rm server-nginx
docker compose up --force-recreate
```

## Delete All Unused Images
```shellscript
docker image prune -a
```

## Re-dockerize Application
```shellscript
docker stop app && docker container rm app && docker image rm custom-image-name
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Custom Container Name)
```shellscript
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Random Container Name)
```shellscript
docker build -t custom-image-name .
docker run -p 3000:3000 --restart=always custom-image-name
```

## Create Container Without Starting; Create Container from an Image
```shellscript
docker container create --name custom-container-name custom-image-name
```

## Dockerize Application (Dockerfile)
```shellscript
docker build -t app .
docker run -p 3000:3000 --restart=always app
```

## Start Container
```shellscript
docker start <container-name>
```

## Rename Container
```shellscript
docker rename old new
```

## Stop Container
```shellscript
docker stop <container-name>
```

## Restart Container
```shellscript
docker restart <container-name>
```

## Update Certificates (Composer Error)
```shellscript
update-ca-certificates
```

## Go to Container's Terminal
```shellscript
docker exec -it <container_name> bash
```

## Build Docker Compose
```shellscript
docker compose up
docker compose build
docker compose up --force-recreate
docker compose build --no-cache
```

## Build Container
* -t to give a docker image a name
* . means the current directory; reference the current directory
```shellscript
docker build -t app .
docker build --no-cache -t app .
```

## Run Docker App/Container
```shellscript
docker run -p 3000:3000 app
```

## Download Image in Docker Hub
```shellscript
docker pull <username>/hello-world
```

## Run Docker Image
```shellscript
docker run hello-world
```

## Show All Running Containers
```shellscript
docker ps
```

## Show All Containers
```shellscript
docker ps -a
```

## Delete Docker Container; Force Delete
* add -f at the end to force delete
```shellscript
docker container rm container-name
```

## Show Docker Images
```shellscript
docker images
```

## Delete Docker Image; Force Delete
* add -f at the end to force delete
```shellscript
docker image rm *first-3-characters-of-the-image-id
```