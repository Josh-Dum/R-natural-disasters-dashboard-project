# Guide Utilisateur 

## Prérequis

Avant de commencer, assurez-vous d'avoir :

- **R** : Installez la version la plus récente de R depuis [CRAN](https://cran.r-project.org/).
- **RStudio** (Optionnel) : Un environnement de développement intégré pour R, disponible sur [RStudio Download](https://www.rstudio.com/products/rstudio/download/).

## Cloner le Dépôt GitHub

1. **Cloner le dépôt** : Ouvrez votre terminal (ou l'invite de commande) et exécutez la commande suivante :

   ```bash
   git clone https://git.esiee.fr/dumontjo/projet_dumont_vigier_dsia4101c_e4_natural_disaster
   ```


2. **Naviguer dans le dossier du projet** :

   ```
   cd [nom du dossier]
   ```

   Remplacez `[nom du dossier]` par le nom de votre dossier de projet cloné.

## Installation des Dépendances

1. **Ouvrir le projet dans RStudio** (si utilisé) et ouvrir le fichier `requirements.txt`.

2. **Installer les packages R nécessaires** :

   ```
   packages <- readLines("requirements.txt")
   install.packages(packages)
   ```

## Téléchargement et Configuration des Données

1. **Placer les fichiers de données** : Assurez-vous que les fichiers `countries.geojson`, `Global Temperature.csv`, `natural_disaster.csv`, `new_dataframe.csv` sont placés dans le bon dossier. 

   Si votre application s'attend à trouver ces fichiers dans un dossier spécifique, placez-les dans ce dossier ou modifiez le chemin d'accès dans le code de l'application.

## Lancement de l'Application

1. **Exécuter l'application** : Dans RStudio (ou un autre environnement R), naviguez jusqu'à l'emplacement du fichier `app.R` et exécutez-le :

   ```
   shiny::runApp("app.R")
   ```
   
# Rapport d'analyse

## Jeux de données

### Premier jeu de données (Fichier `Natural_disaster.csv`)

Le fichier `Natural_disaster.csv` est un ensemble de données complet qui documente diverses catastrophes naturelles survenues à travers le monde. Ces données, provenant de l'EOSDIS (Earth Observing System Data and Information System), fournissent des informations détaillées sur les événements, leur type, leur localisation, ainsi que leur impact humain et économique. Voici une vue d'ensemble des colonnes clés et de ce qu'elles représentent :

1. **Year, Seq, Glide** : Identifiants et références uniques pour chaque événement.
2. **Disaster Group & Subgroup** : Catégorisation générale des catastrophes (par exemple, naturelles, géophysiques).
3. **Disaster Type & Subtype** : Type spécifique de catastrophe (par exemple, inondation, séisme).
4. **Event Name, Country, ISO** : Nom de l'événement, pays et code ISO où il s'est produit.
5. **Region, Continent, Location** : Informations géographiques plus détaillées.
6. **Origin, Associated Dis(1&2), OFDA Response** : Origine de la catastrophe, catastrophes associées et réponses d'urgence.
7. **Appeal, Declaration** : Appels à l'aide et déclarations officielles.
8. **Aid Contribution, Dis Mag(Value & Scale)** : Contributions d'aide et magnitude de la catastrophe.
9. **Latitude, Longitude** : Coordonnées géographiques de l'événement.
10. **Start/End Year, Month, Day** : Dates de début et de fin de l'événement.
11. **Total Deaths, No Injured, No Affected, No Homeless, Total Affected** : Impact humain (décès, blessés, affectés, sans-abris).
12. **Insured Damages, Total Damages, CPI** : Dégâts matériels assurés et totaux, indice des prix à la consommation pour contextualiser économiquement.
13. **Adm Level, Admin1/2 Code, Geo Locations** : Niveaux administratifs concernés et localisations géographiques plus précises.

### Deuxième jeu de données (Fichier `Global Temperature.csv`)

Le fichier `Global Temperature.csv` contient des données détaillées sur les températures mondiales, fournies par Berkeley Earth (https://berkeleyearth.org/data/). Ces données sont essentielles pour analyser les tendances climatiques et comprendre les variations de température sur une longue période. Voici un aperçu des principales colonnes et de leur signification :

1. **Year, Month** : L'année et le mois de l'enregistrement des données.
2. **Monthly Anomaly** : L'écart mensuel de la température par rapport à une moyenne de référence.
3. **Monthly Unc.** : L'incertitude associée à l'anomalie mensuelle.
4. **Annual Anomaly** : L'anomalie annuelle de la température.
5. **Annual Unc** : L'incertitude associée à l'anomalie annuelle.
6. **Five-Year Anomaly, Ten-Year Anomaly, Twenty-Year Anomaly** : Anomalies calculées sur des périodes de cinq, dix et vingt ans pour observer les tendances à long terme.
7. **Uncertainties** : Les incertitudes correspondantes pour les anomalies calculées sur différentes périodes.

### Troisième jeu de données (Fichier `new_dataframe.csv`)

Le fichier `new_dataframe.csv` a été généré en utilisant un processus de géocodage via l'API Google, à partir des données de catastrophes naturelles. Ce fichier contient des informations géolocalisées enrichies pour chaque événement de catastrophe. Voici une brève description du processus utilisé pour créer ce fichier :

#### Processus de Géocodage

Voici le code :
    ```
    import pandas as pd
  import concurrent.futures
  from geopy.geocoders import GoogleV3
  from geopy.extra.rate_limiter import RateLimiter

  # Charger le fichier CSV
  df = pd.read_csv("1900_2021_DISASTERS.xlsx - emdat data.csv")

  # Imprimer le nombre de valeurs manquantes dans la colonne 'Latitude'
  print(df['Latitude'].isna().sum())

  # Initialiser le géolocalisateur
  geolocator = GoogleV3(api_key="AIzaSyBDLRfAKkVqy7HUO49RSpRsleMUVIP7How")
  geocode = RateLimiter(geolocator.geocode, min_delay_seconds=1/50)

  # Créer un dictionnaire de cache
  cache = {}

  def get_coordinates(address):
    # Si l'adresse est dans le cache, retourner le résultat en cache
    if address in cache:
        return cache[address]

    # Sinon, obtenir les coordonnées de l'API
    location = geocode(address)
    if location is not None:
        coordinates = (location.latitude, location.longitude)
    else:
        coordinates = (None, None)

    # Stocker le résultat dans le cache
    cache[address] = coordinates

    return coordinates

  # Appliquer la fonction à chaque ligne du dataframe en parallèle
  with concurrent.futures.ThreadPoolExecutor() as executor:
    df['Latitude'], df['Longitude'] = zip(*executor.map(get_coordinates, df['Location']))

  # Imprimer le nombre de valeurs manquantes dans la colonne 'Latitude' après géocodage
  print(df['Latitude'].isna().sum())

  # Conserver uniquement les colonnes 'Location', 'Latitude' et 'Longitude'
  df = df[['Location', 'Latitude', 'Longitude']]

  # Sauvegarder le nouveau dataframe dans un fichier CSV
  df.to_csv("new_dataframe.csv", index=False)
    ```

1. **Chargement des Données Initiales** : Les données de catastrophes naturelles ont été chargées à partir d'un fichier CSV source.
2. **Géocodage avec l'API Google** : Utilisant l'API GoogleV3 via la bibliothèque `geopy`, chaque emplacement a été géocodé pour obtenir des coordonnées précises.
3. **Utilisation de Rate Limiter** : Pour éviter de dépasser les limites de requêtes de l'API, un `RateLimiter` a été employé.
4. **Caching des Résultats** : Les résultats de géocodage ont été mis en cache pour optimiser les performances et réduire les requêtes inutiles.
5. **Parallélisation du Processus** : Le processus de géocodage a été exécuté en parallèle pour accélérer le traitement.
6. **Nettoyage des Données** : Les colonnes finales sélectionnées étaient 'Location', 'Latitude' et 'Longitude'.
7. **Sauvegarde du Nouveau Fichier CSV** : Les données enrichies ont été sauvegardées dans `new_dataframe.csv`.







