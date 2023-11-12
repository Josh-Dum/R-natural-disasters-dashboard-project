# Guide Utilisateur pour [Nom de l'Application Shiny]

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


