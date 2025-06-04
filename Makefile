.PHONY: build test deploy clean logs status pipeline

LOCAL_IP := 192.168.1.71

pipeline:
	@chmod +x pipeline.sh
	@./pipeline.sh

build:
	@echo "🔨 Building containers..."
	docker-compose build

test:
	@echo "🧪 Testing application..."
	docker-compose up -d app
	@sleep 3
	@curl -f http://localhost:5000/health || (docker-compose down && exit 1)
	@echo "✅ Tests passed"

deploy:
	@echo "🚀 Deploying locally..."
	docker-compose up -d
	@echo "✅ Deployed at http://$(LOCAL_IP)"

clean:
	docker-compose down -v
	docker system prune -f

logs:
	docker-compose logs -f

status:
	@echo "📊 Container Status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

restart:
	docker-compose restart
	@echo "🔄 Restarted at http://$(LOCAL_IP)"