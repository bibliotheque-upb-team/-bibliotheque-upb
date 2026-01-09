# Guide Git pour l'Équipe 🚀

## 📖 Les Bases

### C'est quoi Git ?
Git = Logiciel pour travailler à plusieurs sur du code

### C'est quoi GitHub ?
GitHub = Site web où on met le code (comme Google Drive)

### C'est quoi un Repository ?
Repository (Repo) = Le dossier du projet sur GitHub

### C'est quoi un Commit ?
Commit = Sauvegarder tes modifications avec un message

### C'est quoi une Branche ?
Branche = Une version parallèle du code

## 🎯 Workflow Quotidien

### 1️⃣ Avant de commencer à coder
```bash
# Récupère les dernières modifications
git pull origin develop
```

### 2️⃣ Créer ta branche (première fois)
```bash
# Backend
git checkout -b backend/nom-feature

# Mobile
git checkout -b mobile/nom-feature

# Web
git checkout -b web/nom-feature
```

### 3️⃣ Pendant que tu codes
```bash
# Voir ce que tu as modifié
git status

# Ajouter tes fichiers
git add .

# Sauvegarder (commit)
git commit -m "[BACKEND] Description de ce que tu as fait"

# Envoyer sur GitHub
git push origin ta-branche
```

### 4️⃣ Quand ta feature est finie

1. **Va sur GitHub**
2. **Clique "Pull Request"**
3. **Le chef va vérifier et merge**

## 📝 Format des Messages de Commit

### ✅ BONS EXEMPLES
```bash
git commit -m "[BACKEND] Add User entity"
git commit -m "[MOBILE] Create login screen"
git commit -m "[WEB] Add book list page"
git commit -m "[FIX] Correct button alignment"
```

### ❌ MAUVAIS EXEMPLES
```bash
git commit -m "update"
git commit -m "fix"
git commit -m "changes"
```

## 🆘 Commandes Utiles
```bash
# Voir l'historique
git log --oneline

# Annuler les modifications non sauvegardées
git checkout -- .

# Voir les différences
git diff
```

## ⚠️ En Cas de Problème

**STOP !** Demande dans le groupe WhatsApp avant de faire n'importe quoi !

**NE FAIS JAMAIS** :
- `git push --force` (sauf si le chef te le dit)
- Supprimer des fichiers sans demander
- Modifier le code d'un autre sans prévenir