#!/bin/bash
clear
docker-compose down -v; docker-compose build && docker-compose up -d --force-recreate