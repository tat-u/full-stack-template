# Start the containers in detached mode
up:
# `-d` により、勝手にターミナルがアタッチされないようにする
	docker-compose up -d

# Stop and remove the containers
down:
	docker-compose down
