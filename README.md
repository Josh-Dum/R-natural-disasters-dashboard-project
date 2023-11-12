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

##Jeux de données

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




