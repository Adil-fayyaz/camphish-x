# Come pubblicare su GitHub

## 1. Login GitHub CLI

Apri il terminale e esegui:

```bash
gh auth login
```

Scegli:
- **GitHub.com**
- **HTTPS**
- **Login with browser** (più facile)

Completa il login nel browser.

---

## 2. Crea il repository e pusha

Dalla cartella del progetto:

```bash
cd "c:\Users\adil\Downloads\CamPhish-main\CamPhish-main"

gh repo create camphish-x --public --source=. --remote=origin --push
```

Questo crea il repo `camphish-x` (Hack Cam) sul tuo account GitHub e carica tutto.

---

## 3. Se il repo esiste già

Se hai già creato il repo manualmente:

```bash
git remote add origin https://github.com/Adil-fayyaz/camphish-x.git
git branch -M main
git push -u origin main
```

Hack Cam - Created by Infinity x White Devels Team

---

## 4. Repository

Hack Cam - https://github.com/Adil-fayyaz/camphish-x
Created by Infinity x White Devels Team
