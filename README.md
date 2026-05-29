# Weather App
 
Application météo mobile développée avec Flutter dans le cadre d'un TP Bac+3.
 
## Fonctionnalités
 
- Recherche météo par nom de ville
- Affichage de la température, vitesse du vent, humidité, ressenti thermique et indice UV
- Icônes météo selon les conditions (soleil, nuages, pluie, neige, orage)
- Indicateur de chargement animé
- Gestion des erreurs (ville introuvable, champ vide, erreur réseau)
- Support multilingue français / anglais (détection automatique selon la langue du téléphone)
## Stack technique
 
- **Flutter**
- **API** : [Open-Meteo](https://open-meteo.com/) 
- **Packages** :
  - `http` — requêtes HTTP
  - `easy_localization` — internationalisation (i18n)
## Architecture
 
```
lib/
  main.dart               # Point d'entrée
  pages/
    home_page.dart        # Écran principal
  api/
    weather_api.dart      # Appels API (géocodage + météo)
assets/
  images/                 # Icônes météo
  locales/
    fr.json               # Traductions françaises
    en.json               # Traductions anglaises
```
 
## Installation
 
1. Cloner le dépôt
```bash
git clone https://github.com/trentycha/weather_app.git
cd weather_app
```
 
2. Installer les dépendances
```bash
flutter pub get
```
 
3. Lancer l'application
```bash
flutter run
```
 
## API utilisée
 
L'application utilise deux endpoints Open-Meteo :
 
| Étape | Endpoint | Rôle |
|-------|----------|------|
| 1 | `geocoding-api.open-meteo.com/v1/search` | Convertir un nom de ville en latitude/longitude |
| 2 | `api.open-meteo.com/v1/forecast` | Récupérer les données météo |