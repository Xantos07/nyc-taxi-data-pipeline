# Module 01 - NYC Taxi Data Pipeline

Ce module implémente un pipeline de données pour ingérer et analyser les données des taxis de New York dans une base de données PostgreSQL.

## 📋 Vue d'ensemble

Le projet utilise Docker pour orchestrer PostgreSQL et pgAdmin, avec un script Python pour ingérer les données de taxis NYC depuis des fichiers CSV.

Cours : [DataTalksClub module-01 docker](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/01-docker-terraform/2_docker_sql)

## 🗂️ Structure du projet

```
module-01/
├── ingest_data.py          # Script d'ingestion des données
├── Dockerfile              # Image Docker pour l'ingestion
├── docker-compose.yaml     # Configuration Docker Compose
├── yellow_tripdata_2021-01.csv
├── taxi_zone_lookup.csv
└── ny_taxi_postgres_data/  # Volume persistant PostgreSQL
```

## 📊 Sources de données

- **Données des trajets** : [yellow_tripdata_2021-01.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz)
- **Zones de taxi** : [taxi_zone_lookup.csv](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv)

## 🚀 Démarrage rapide

### Option 1 : Docker Compose 

```bash
docker-compose up -d
```

Cette commande lance :
- PostgreSQL sur le port `5432`
- pgAdmin sur le port `8080` (http://localhost:8080)

### Option 2 : Commandes Docker manuelles

#### 1. Créer le réseau Docker

```bash
docker network create pg-network
```

#### 2. Lancer PostgreSQL

```bash
docker run -d \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v //$(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
```

#### 3. Lancer pgAdmin

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin-2 \
  dpage/pgadmin4
```

## 📥 Ingestion des données

### Méthode 1 : Script Python local

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}
```

### Méthode 2 : Container Docker

#### Construire l'image

```bash
docker build -t taxi_ingest:v001 .
```

#### Lancer l'ingestion

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
winpty docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

## 🔧 Configuration

### Base de données PostgreSQL

- **User** : root
- **Password** : root
- **Database** : ny_taxi
- **Port** : 5432

### pgAdmin

- **Email** : admin@admin.com
- **Password** : root
- **URL** : http://localhost:8080

## 📝 Description des fichiers

### `ingest_data.py`

Script principal d'ingestion qui :
- Télécharge les données CSV depuis une URL
- Convertit les colonnes de dates
- Charge les données par chunks (100 000 lignes) dans PostgreSQL
- Utilise SQLAlchemy pour la connexion

### `Dockerfile`

Image basée sur Python 3.9 avec :
- wget pour télécharger les fichiers
- pandas, sqlalchemy, psycopg2 pour le traitement et l'insertion

### `docker-compose.yaml`

Orchestre PostgreSQL et pgAdmin avec configuration réseau automatique

## 🛠️ Commandes utiles

### Arrêter les containers

```bash
docker-compose down
```

### Voir les logs

```bash
docker logs pg-database
docker logs pgadmin-2
```

### Accéder à PostgreSQL en ligne de commande

```bash
docker exec -it pg-database psql -U root -d ny_taxi
```

## 📚 Références

Basé sur le cours [DataTalksClub - Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)
