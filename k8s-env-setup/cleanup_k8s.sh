#!/bin/bash
set -e

echo "=== Cleanup Script: Remove Docker, kubectl, Minikube ==="

# Function to remove a binary if exists
remove_binary() {
    local binary_path
    binary_path=$(command -v "$1" 2>/dev/null || true)

    if [ -n "$binary_path" ]; then
        echo "🗑 Removing $1 from $binary_path"
        sudo rm -f "$binary_path"
    else
        echo "✅ $1 already removed or not found"
    fi
}

# --- Remove Docker ---
echo "🧼 Removing Docker..."

sudo systemctl stop docker || true
sudo systemctl disable docker || true

sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
sudo rm -rf /var/lib/docker /etc/docker ~/.docker
sudo rm -rf /var/lib/containerd

sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

remove_binary docker
remove_binary docker-compose

# --- Remove kubectl ---
echo "🧼 Removing kubectl..."
remove_binary kubectl

# Also remove snap kubectl if installed
if snap list | grep -q kubectl; then
    echo "🗑 Removing kubectl installed via snap"
    sudo snap remove kubectl
fi

# --- Remove Minikube ---
echo "🧼 Removing Minikube..."
remove_binary minikube

# Remove local minikube configs
sudo rm -rf ~/.minikube ~/.kube

echo "✅ All components have been cleaned from the system."
