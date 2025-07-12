# 🚀 Local Kubernetes + Docker Setup

This repository provides shell scripts to **install** and **uninstall** a complete local Kubernetes environment using:

- 🐳 Docker  
- 📦 kubectl  
- 🌱 Minikube  

---

## 📁 Files Included

| Script           | Purpose                                                                 |
|------------------|-------------------------------------------------------------------------|
| `setup_k8s.sh`   | Installs Docker, kubectl, Minikube and starts the cluster               |
| `cleanup_k8s.sh` | Completely removes Docker, kubectl, Minikube, and related config files  |

---

## ⚙️ Installation Steps

> 💡 These steps are for **Ubuntu 20.04+** systems. Internet connection is required.

### 1. ✅ Make the setup script executable

```bash
chmod +x setup_k8s.sh
```

### 2. ▶️ Run the setup script

```bash
./setup_k8s.sh
```

The script will:

- Detect if Docker, kubectl, and Minikube are already installed  
- Verify their binaries are working  
- If missing or invalid, it downloads and installs the correct versions  
- Starts a local Minikube cluster using the Docker driver  

---

## ✅ Post-Installation Validation

### 🐳 Docker

```bash
docker --version
docker ps
```

### 📦 kubectl

```bash
kubectl version --client
kubectl get nodes
```

### 🌱 Minikube

```bash
minikube version
minikube status
```

If Minikube is working properly, you should see your node in `Ready` status:

```bash
kubectl get nodes
```

Example output:

```text
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   2m10s   v1.33.x
```

---

## 🧹 Uninstallation / Cleanup

### 1. ✅ Make the cleanup script executable

```bash
chmod +x cleanup_k8s.sh
```

### 2. 🗑️ Run the cleanup script

```bash
./cleanup_k8s.sh
```

This will:

- Stop and delete the Minikube cluster  
- Remove kubectl from `/usr/local/bin` and Snap (if installed)  
- Remove Docker binaries  
- Clean config folders like `~/.kube`, `~/.minikube`, etc.

---

## 📝 Notes

- If you’ve previously installed Docker or Kubernetes via **Snap**, **APT**, or other package managers, the script will try to remove those as well.  
- The setup script ensures binaries are valid by **executing version commands** like `docker --version`, not just checking their paths.  
- If you only want to reset Minikube (not uninstall everything), use:

```bash
minikube delete
```

---

## 👨‍💻 Author

**Vishwajit**

This project was created to simplify local Kubernetes environment setup for **learning and testing**.  
Feel free to **contribute**, **fork**, or **modify** it for your use case.

---

## 🔐 License

**MIT License** – free to use and distribute.
