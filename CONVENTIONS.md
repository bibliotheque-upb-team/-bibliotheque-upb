# Conventions de Code

## 📝 Nommage

### Backend (Java)
- **Classes** : `UserController`, `BookService` (PascalCase)
- **Méthodes** : `createUser()`, `findById()` (camelCase)
- **Variables** : `userName`, `bookList` (camelCase)
- **Constantes** : `MAX_LOANS`, `JWT_SECRET` (MAJUSCULES)

### Frontend (Dart)
- **Fichiers** : `login_screen.dart`, `book_card.dart` (snake_case)
- **Classes** : `LoginScreen`, `BookCard` (PascalCase)
- **Variables** : `userName`, `bookList` (camelCase)

## 📁 Organisation

### Backend
src/main/java/com/upb/bibliotheque/
├── controller/    # REST Controllers
├── service/       # Logique métier
├── repository/    # Accès données
├── entity/        # Entités JPA
└── dto/           # Data Transfer Objects
### Frontend
lib/
├── screens/       # Écrans
├── widgets/       # Composants
├── services/      # API
├── models/        # Modèles
└── providers/     # State
## 🔀 Git

**Branches :**
- `main` → Production
- `develop` → Développement
- `backend/feature-name` → Features backend
- `mobile/feature-name` → Features mobile
- `web/feature-name` → Features web

**Commits :**
Modules : BACKEND, MOBILE, WEB, DB, DOC, FIX
## ✅ Règles

1. **Toujours** tester avant de push
2. **Toujours** commit avec un message clair
3. **Toujours** pull avant de commencer
4. **Jamais** commit des mots de passe
5. **Jamais** push sur `main` directement
