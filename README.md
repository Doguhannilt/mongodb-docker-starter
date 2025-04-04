

## Quick Start

### 1. Start the MongoDB Container

```bash
./scripts/start-db.sh
```

This will:
- Create a Docker volume (if not exists)
- Create a Docker network (if not exists)
- Start a MongoDB container with custom credentials
- Mount an init script to configure your database and user

---

### 2. Stop & Clean Up the Environment

```bash
./scripts/cleanup.sh
```

This will:
- Remove the MongoDB container (if running)
- Remove the Docker volume
- Remove the Docker network

---

## ⚙️ Environment Configuration

The scripts rely on the following environment files:

| File             | Description                     |
|------------------|---------------------------------|
| `.env.db`        | Database container name         |
| `.env.network`   | Custom Docker network name      |
| `.env.volume`    | Docker volume name              |

> Example `.env.db`:
```env
DB_CONTAINER_NAME=mongodb
```

---

## 🧩 Initialization Script

The following file is mounted on container startup:

```bash
db-config/mongo-init.js
```

It creates the application-specific database and user with custom roles.

> Example content:
```js
const key_value_db = process.env.KEY_VALUE_DB;
const keyValueUser = process.env.KEY_VALUE_USER;
const keyValuePassword = process.env.KEY_VALUE_PASSWORD;

db = db.getSiblingDB(key_value_db);

db.createUser({
    user: keyValueUser,
    pwd: keyValuePassword,
    roles: [{ role: 'readWrite', db: key_value_db }]
});
```

---

## 📁 Project Structure

```bash
.
├── db-config/
│   └── mongo-init.js
├── scripts/
│   ├── start-db.sh
│   └── cleanup.sh
├── .env.db
├── .env.network
├── .env.volume
└── README.md
```

---

## 🧼 Notes

- The MongoDB image used: `mongodb/mongodb-community-server:7.0-ubuntu2204`
- Container is run with `--rm` so it's ephemeral. Data persists via Docker volume.
- Ensure Docker is running before executing the scripts.

