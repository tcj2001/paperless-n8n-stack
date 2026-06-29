# Paperless Stack

Docker Compose stack for running Paperless-ngx with optional local AI capabilities.

This exactly same as the original authors setup, i just added n8n and syncthing, in case I plan to use it

## Quick Start

1. **Clone and configure**

   ```bash
   git clone https://github.com/tcj2001/paperless-n8n-stack.git
   cd paperless-n8n-stack
   ```

2. **Edit environment files**

   Update passwords and secrets in each service's `.env` file:
   - `./paperless/.env` - Paperless configuration
   - `./postgres-n8n/.env` - Database credentials (must match Paperless config)
   - Other service `.env` files as needed

3. **Start the stack**
   
   for n8n-runner custom build (using Dokerfile and extras.txt)
   ```bash
   docker build -t n8n-runner:custom .
   ```

   start/re-start containers
   ```bash
   docker compose up -d
   or
   docker compose down && docker compose up -d
   ```

   Open <http://localhost:8000> and create your Paperless admin account.

5. **Optional: Configure AI services**

   For AI features, you'll need to:
   - Open Open WebUI at <http://localhost:3001> and pull models:
     - `llama3.2:3b` (lightweight, for metadata suggestions and document reasoning)
     - `minicpm-v:8b` (vision model, for improved OCR)
     - These should match the models listed in  `./paperless-ai/.env` and `./paperless-gpt/.env
   - In Paperless, go to Profile → API Tokens → Generate
   - Copy the token and add it to `./paperless-ai/.env` and `./paperless-gpt/.env`
   - Update `./paperless-ai/.env` with Paperless username
   - Restart services: `docker compose restart`

**The AI components are entirely optional** and can be disabled by commenting them out. Paperless works great without AI.

## Access

| Service | URL |
| ------- | --- |
| Paperless-ngx | <http://localhost:8000> |
| Open WebUI | <http://localhost:3001> |
| Paperless-AI | <http://localhost:3000> |
| Paperless-GPT | <http://localhost:3002> |
| n8n | <http://localhost:3003> |
| syncthing | <http://localhost:8384> |
| Dozzle (logs) | <http://localhost:8080> |


## What's Included

- Pre-configured environment files for all services
- Paperless-ngx with OCR, tagging, and search capabilities
- PostgreSQL database and Redis cache
- Document conversion and text extraction (Gotenberg, Tika)
- Optional local AI features:
  - Ollama for local LLM inference
  - Open WebUI for model management
  - Paperless-AI for metadata suggestions
  - Paperless-GPT for vision-based OCR improvements and metadata suggestions
- Log viewer with Dozzle

## Basic Usage

- **Add documents**: Drop files in `./paperless/consume/` folder
- **Search documents**: Use the search bar in Paperless web interface
- **View logs**: Use Dozzle at <http://localhost:8080>

## Important Notes

- **Security**: Use a VPN for remote access. Don't expose these services directly to the internet.
- **Backups**: Back up `./paperless/data/`, `./paperless/media/`, and `./postgres/data/`
- **Updates**: Run `docker compose pull && docker compose up -d`

## Resources

- **Detailed Guide**: [Self-Hosted Paperless-ngx + Optional Local AI](https://technotim.com/posts/paperless-ngx-local-ai/)
- **Video Tutorial**: [Paperless-ngx + Local AI (Optional): Better OCR, Self-Hosted, No Cloud](https://www.youtube.com/watch?v=NMAwHjleqHg)

## Troubleshooting

- Check logs: `docker compose logs [service-name]` or use Dozzle at <http://localhost:8080>
- Check service status: `docker compose ps`
- Verify database credentials match between paperless and postgres .env files
- For AI issues, ensure Ollama is running and models are downloaded

**For detailed troubleshooting including AI setup, vision OCR, and workflows, see the guide above.**

## Acknowledgments

This stack is built using these awesome open-source projects:

- **[Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)** - Document management system with OCR and search
- **[Ollama](https://github.com/ollama/ollama)** - Local LLM inference
- **[Open WebUI](https://github.com/open-webui/open-webui)** - Web interface for Ollama
- **[Paperless-AI](https://github.com/clusterzx/paperless-ai)** - AI-powered metadata suggestions
- **[Paperless-GPT](https://github.com/icereed/paperless-gpt)** - Vision OCR for Paperless
- **[PostgreSQL](https://github.com/postgres/postgres)** - Database system
- **[Redis](https://github.com/redis/redis)** - Cache and message broker
- **[Gotenberg](https://github.com/gotenberg/gotenberg)** - Document conversion API
- **[Apache Tika](https://github.com/apache/tika)** - Content detection and extraction
- **[Dozzle](https://github.com/amir20/dozzle)** - Real-time log viewer for Docker

Special thanks to the maintainers and contributors of these projects for making self-hosted document management and local AI accessible.

##Trouble shooting

Clear paperless-ngx
```bash
docker exec -it paperless-ngx python3 manage.py shell
from documents.models import Document
Document.objects.all().delete()
exit()
```

Start processing consume folder in paperless-ngx
```bash
docker exec -it paperless-ngx python3 manage.py document_consumer
```

Delete postgress-paperless database
```bash
docker compose down
sudo rm -rf ./postgres-paperless
add back .env in /postgress-paperless
docker compose up -d
```

Force recrate
```bash
docker compose up -d --force-recreate paperless-ai
```

Docker install
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Nvidia driver install
```bash
sudo ubuntu-drivers autoinstall
or
apt install nvidia-utils-595-server
```

check gpus
```bash
nvidia-smi
```

Install Nvidia Toolkit
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

Configure docker to use nvidia
```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

To remove and reinstall
```bash
docker stop $(docker ps -q)
docker system prune -a --volumes
```

