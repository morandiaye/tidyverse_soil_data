# Tidyverse 
SOTER Data 
tidyverse_soil_data

Un dépôt R/Tidyverse pour importer, nettoyer, analyser et visualiser des données de sol.


# Description

Ce projet fournit une pipeline de traitement de données de sol (soil data) basée sur le tidyverse (R). Il permet d'importer des données brutes, de les nettoyer, de faire des transformations utiles, puis d’effectuer des visualisations et analyses exploratoires.

# Objectifs principaux :

Garantir la reproductibilité des analyses

Mettre en place des étapes claires de nettoyage et transformation des données

Faciliter la visualisation et la compréhension des données de sol

# Fonctionnalités

- Importation de différents formats de données (CSV, Excel, etc.)

- Nettoyage des données : gestion des valeurs manquantes, formatage des colonnes, typage correct, etc.

- Transformation : calculs dérivés, regroupements, filtres, agrégation

- Visualisation exploratoire (histogrammes, boxplots, cartes, etc.)

- Préparation des données pour modélisation ou cartographie

# Données

- Origine : (À préciser — source des données de sol, par exemple laboratoires, institutions, bases publiques…)

- Format : sont-ce des fichiers .csv, .xls, .xlsx, .txt, des données spatiales ?

- Variables typiques : pH, texture du sol (sable, limon, argile), humidité, matière organique, etc.

- Problématiques particulières : valeurs manquantes, unités différentes, mesures répétées, etc.

# Installation & Pré-requis

Pré-requis : R version ≥ 4.x

Packages R : tidyverse, éventuellement readxl, sf (si données spatiales), ggplot2, etc.

Installation :
- Cloner le dépôt git clone https://github.com/morandiaye/tidyverse_soil_data.git

- Aller dans le dossier du projet setwd("tidyverse_soil_data")

- Installer les dépendances nécessaires install.packages(c("tidyverse", "readxl", "sf", "lubridate", "ggplot2", …))

# Utilisation

Voici un exemple d’utilisation :

library(tidyverse)
Charger les fonctions/utilitaires, par exemple un script R dans /R ou /src
source("R/clean_soil_data.R")

# Importer données brutes
soil_raw <- import_soil_data("data/soil_raw.csv")

# Nettoyer
soil_clean <- clean_soil_data(soil_raw)

# Transformer / créer de nouvelles variables
soil_transformed <- soil_clean %>% mutate(pH_adj = …, # exemple  sand_prop = sand / total_texture)

# Visualiser
soil_transformed %>%
  ggplot(aes(x = pH_adj, y = matière_organique)) +
  geom_point() +
  theme_minimal()

# Exemples

Tu peux inclure ici des captures d’écran ou graphiques générés, ou des notebooks (.Rmd) démontrant :

- Analyse exploratoire de la distribution de pH

- Cartographie spatiale si applicable

- Comparaison entre types de sols / sites / profondeur

