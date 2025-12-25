# Project Zomboid – Dedicated Server (Docker)

Image Docker générique pour déployer un serveur dédié Project Zomboid (vanilla).
Cette image fournit uniquement l’environnement système nécessaire au serveur.

Le jeu est téléchargé, mis à jour et exécuté dynamiquement au runtime via SteamCMD.
Aucune donnée de jeu n’est embarquée dans l’image.

## Objectifs du projet

- Serveur vanilla uniquement
- Aucun mod géré par l’image
- Toutes les données persistées dans un volume
- Mises à jour automatiques via SteamCMD
- Logs visibles sur la sortie standard Docker
- Compatible Docker Compose / Portainer
- Architecture amd64 uniquement

## Principe de fonctionnement

- Démarrage sur Debian (bookworm)
- Installation automatique de SteamCMD au premier lancement
- Téléchargement ou mise à jour du serveur Project Zomboid
- Lancement immédiat du serveur
- Toutes les données runtime sont stockées dans un volume Docker

## Arborescence persistée

/pz
├── systeme/
│   ├── steamcmd/
│   └── server/
└── Zomboid/
    ├── Server/
    ├── Saves/
    ├── Logs/
    └── Workshop/

Toutes les données sont persistées.

## Variables d’environnement

Obligatoire :
- PZ_ADMIN_PASSWORD : mot de passe administrateur

Optionnelles :
- STEAM_BETA_BRANCH (défaut : public)
- PZ_SERVER_NAME (défaut : pzserver)

## Ports utilisés

- 16261/udp : port principal serveur
- 16262/udp : port joueurs
- 8766/udp  : Steam

## Exemple docker-compose.yml

services:
  project-zomboid:
    image: yourdockerhubuser/project-zomboid:latest
    container_name: project-zomboid-server
    restart: unless-stopped
    environment:
      PZ_ADMIN_PASSWORD=change_me
      STEAM_BETA_BRANCH=public
      PZ_SERVER_NAME=pzserver
    volumes:
      - pz-data:/pz
    ports:
      - "16261:16261/udp"
      - "16262:16262/udp"
      - "8766:8766/udp"

volumes:
  pz-data:

## Logs

Tous les logs sont envoyés sur stdout/stderr et consultables via docker logs ou Portainer.

## Mise à jour

Un simple redémarrage du conteneur déclenche la vérification et la mise à jour du serveur.

## Licence

Cette image fournit uniquement un environnement Docker.
Project Zomboid et SteamCMD restent soumis à leurs licences respectives.
