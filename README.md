
# 📱 CryptoWatch

**CryptoWatch** est une application Flutter multiplateforme (iOS & macOS) qui permet de suivre en temps réel l’évolution du marché des crypto-monnaies à l’aide de l’API open source [CoinGecko](https://www.coingecko.com/en/api).

---

## 🚀 Fonctionnalités

### 🔸 1. Liste des crypto-monnaies
- Affichage des 20 principales cryptos (nom, symbole, logo, prix)
- Tri dynamique par prix ou par nom 

### 🔸 2. Détail d’une crypto
- Description, prix actuel, variation 24h / 7 jours / 30 jours
- Graphique sparkline (évolution sur 24h / 7 jours / 30 jours)
- Lien vers le site officiel

### 🔸 3. Gestion des favoris
- Ajout / suppression depuis la liste ou la fiche
- Stockage local avec Hive
- Badge affichant le nombre de cryptos suivies

### 🔸 4. Conversion des prix
- Choix de la devise (EUR, USD, GBP)
- Conversion dynamique via l’API
- Préférence sauvegardée localement

---

## 🧱 Architecture

Structure basée sur MVVM simplifié :

```
/lib
├── models/
├── services/
├── viewmodels/
├── views/
├── widgets/
├── main.dart
└── routes.dart
```

---

## 🛠️ Technologies utilisées

- **Flutter**
- **Dart**
- **Provider** (state management)
- **Hive** (stockage local)
- **HTTP** (requêtes API)
- **fl_chart** (graphique sparkline)

---

## 📦 API utilisée

- [CoinGecko API](https://www.coingecko.com/en/api) – Accès libre

---

## 📅 Objectif pédagogique

Projet réalisé dans le cadre de l’évaluation Flutter B3 :

- App multiplateforme (iOS/macOS)
- Intégration API REST
- Widgets personnalisés
- Animations simples
- Stockage local

---

## 👨‍💻 Développé par

**RIBEIRO Thomas**  
Mastère 2 – Ingénierie du web  
Campus : CAMPUS ESGI Lille
Date : Mai 2025

---
****