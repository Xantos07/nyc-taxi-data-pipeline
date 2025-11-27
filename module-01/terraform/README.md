# Terraform - Google Cloud Platform

Ce dossier contient la configuration Terraform pour provisionner les ressources GCP nécessaires au projet NYC Taxi Data Pipeline.

## 📋 Prérequis

- [Terraform](https://www.terraform.io/downloads.html) = 7.12.0 ou supérieur installé
- Compte [Google Cloud Platform](https://cloud.google.com/)
- Projet GCP créé avec facturation activée
- Clé de service GCP (fichier JSON)

## 🔑 Configuration de l'authentification

### 1. Créer une clé de service GCP

#### Étape 1 : Créer le compte de service

1. **IAM & Admin** → **Service Accounts**
2. Cliquer sur **Create Service Account**
3. Donner un nom au compte (ex: `terraform-sa`)

#### Étape 2 : Assigner les rôles

Assigner les rôles suivants au compte de service :
- **Storage Admin** (gérer les buckets Cloud Storage)
- **Storage Object Admin** (gérer les objets dans les buckets)
- **BigQuery Admin** (gérer BigQuery)

#### Étape 3 : Générer la clé JSON

1. Cliquer sur le compte de service créé
2. Onglet **Keys** → **Add Key** → **Create new key**
3. Sélectionner **JSON** et cliquer sur **Create**
4. La clé JSON sera téléchargée automatiquement

#### ⚠️ Résolution de problèmes : Création de clé bloquée

Si la création de clé est désactivée par les règles de sécurité de votre organisation :

**Option 1 : Désactiver la règle**

1. Aller dans Règles d'administration
2. Dans la barre de recherche, taper : `iam.disableServiceAccountKeyCreation`
3. Cliquer sur **Disable Service Account Key Creation**
4. Cliquer sur **gérer la règle**
6. Réessayer de créer la clé

**Option 2 : Obtenir les permissions nécessaires**

Si vous ne pouvez pas modifier la règle :

1. Sélectionner votre organisation (pas votre projet) (en haut)
2. Ajouter le rôle **Administrateur des règles de l'organisation
** à votre compte
3. Retourner dans **Règles d'administration** et suivre l'Option 1

### 2. Placer la clé dans le projet

dans un dossier `keys/` à la racine de ce dossier terraform.
et renommer la clé en `my-creds.json`.
⚠️ **Important** : Le dossier `keys/` est dans le `.gitignore` pour éviter de pousser vos credentials sur GitHub.

## 🚀 Utilisation de Terraform

### Initialiser Terraform

```bash
terraform init
```

### Prévisualiser les changements

```bash
terraform plan
```

Affiche les ressources qui seront créées/modifiées/supprimées.

### Appliquer la configuration

```bash
terraform apply
```

Crée les ressources sur GCP. Tapez `yes` pour confirmer.

### Détruire les ressources

```bash
terraform destroy
```

⚠️ Supprime **toutes** les ressources créées par Terraform. Tapez `yes` pour confirmer.

## 📦 Ressources provisionnées

### Google Cloud Storage Bucket

- **Nom** : `project-38f9ae16-bea2-4d91-8e8-terra-bucket`
- **Région** : `europe-west1`
- **Configuration** :
  - Accès uniforme au niveau du bucket activé
  - Suppression forcée activée
  - Lifecycle rule : suppression automatique après 1 jour

```hcl
resource "google_storage_bucket" "demo-bucket" {
  name          = "project-38f9ae16-bea2-4d91-8e8-terra-bucket"
  location      = "europe-west1"
  force_destroy = true
  
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}
```

## 🛠️ Commandes utiles

### Formater le code Terraform

```bash
terraform fmt
```

### Valider la configuration

```bash
terraform validate
```

### Voir l'état actuel

```bash
terraform show
```

### Lister les ressources gérées

```bash
terraform state list
```

## 📁 Structure

```
terraform/
├── main.tf                 # Configuration principale
├── README.md              
├── terraform.tfstate      # État Terraform (généré)
├── terraform.tfstate.backup
└── keys/
    └── my-creds.json      # Clé GCP (dans .gitignore)
```

## ⚙️ Configuration du projet

Modifier les valeurs dans `main.tf` selon vos besoins :

```hcl
provider "google" {
  project = "votre-project-id"  # ID de votre projet GCP
  region  = "europe-west1"      # Région par défaut
}
```

## 🔒 Sécurité

✅ **À faire :**
- Garder `keys/` dans `.gitignore`
- Ne jamais commiter les fichiers `*.json` de credentials
- Utiliser des variables d'environnement pour les secrets

❌ **À ne pas faire :**
- Pousser `terraform.tfstate` sur un repo public (contient des infos sensibles)
- Partager votre clé de service
- Commiter `keys/my-creds.json`

## 📚 Ressources

- [Documentation Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Storage Bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
