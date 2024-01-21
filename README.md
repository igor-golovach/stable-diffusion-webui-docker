# stable-diffusion-webui-docker

## Usage

1. Create `.env` file and specify the `DEVICE_UUID`, `PORT` (refer to `.env.example`)
2. `docker compose up -d --no-deps --build`
3. Open [http://localhost:7870](http://localhost:7870)
4. You can bring the containers down by `docker compose stop`