#!/bin/bash

curl https://start.spring.io/starter.zip \
    -d type=maven-project \
    -d language=java \
    -d bootVersion=3.2.1 \
    -d baseDir=bigbang \
    -d groupId=com.example \
    -d artifactId=bigbang \
    -d name=BigBang \
    -d description="Demo project for Spring Boot Backend" \
    -d packageName=com.example.bigbang \
    -d packaging=jar \
    -d javaVersion=21 \
    -d dependencies=web,data-jpa,security,devtools,actuator,lombok,validation,postgresql \
    -o bigbang.zip

read -p "Please ENTER to exit..."