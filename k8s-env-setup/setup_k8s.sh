#!/bin/bash
set -e

echo "=== Kubernetes + Docker Setup Script with Full Binary Check ==="

# Function to check if a binary exists and is executable
check_system_binary() {
    local binary_name="$1"
    local bin_path

    bin_path=$(command -v "$binary_name" 2>/dev/null || true)

    if [ -n "$bin_path" ] && [ -x "$bin_path" ] && [ -f "$bin_path" ]; then
        echo "✅ $binary_name is already installed at $bin_path"
        return 0
    else
        echo "❌ $binary_name not found or invalid"
        return 1
    fi
}

# ------------------------
# Docker Installation
# ------------------------
if ! check_system_binary docker; then
    echo "🛠 Installing Docker..."

    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable docker
    sudo systemctl start docker
fi

# ------------------------
# kubectl Installation
# ------------------------
if ! check_system_binary kubectl; then
    echo "🛠 Installing kubectl..."

    KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)

    if [[ "$KUBECTL_VERSION" != v* ]]; then
        echo "❌ Invalid kubectl version received: $KUBECTL_VERSION"
        exit 1
    fi

    echo "📦 Downloading kubectl version: $KUBECTL_VERSION"
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    echo "✅ kubectl installed at /usr/local/bin/kubectl"
fi

# ------------------------
# Minikube Installation
# ------------------------
if ! check_system_binary minikube; then
    echo "🛠 Installing Minikube..."

    if [ -f "./minikube-linux-amd64" ]; then
        echo "➡️ Found local minikube binary. Installing..."
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    else
        echo "⬇️ Downloading Minikube..."
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    fi

    echo "✅ Minikube installed at /usr/local/bin/minikube"
fi

# ------------------------
# Start Minikube
# ------------------------
echo "🚀 Starting Minikube with Docker driver..."
minikube start --driver=docker

echo "🎉 Setup Complete! You can now run: kubectl get nodes"
