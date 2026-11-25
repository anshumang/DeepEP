#!/usr/bin/env bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH --time=01:30:00

set -euo pipefail

: "${TASK_ROOT:?set TASK_ROOT to the staged ticket workspace}"
: "${SOURCE_DIR:?set SOURCE_DIR to its DeepEP repository}"
: "${CUDA_HOME:=/usr/local/cuda}"

export PATH="/opt/slurm/bin:${CUDA_HOME}/bin:${PATH}"

mkdir -p "${TASK_ROOT}/logs" "${TASK_ROOT}/build"
exec > >(tee "${TASK_ROOT}/logs/slurm-${SLURM_JOB_ID}.log") 2>&1

echo "start=$(date -u +%FT%TZ) host=$(hostname) job=${SLURM_JOB_ID}"
experiment-probe || true
nvidia-smi --query-gpu=name,driver_version --format=csv,noheader | head -1
nvcc --version | tail -1

nvcc -std=c++20 \
    -I"${SOURCE_DIR}/deep_ep/include" \
    -I"${SOURCE_DIR}" \
    "${SOURCE_DIR}/tests/elastic/test_gin_resource_alloc.cu" \
    -o "${TASK_ROOT}/build/test_gin_resource_alloc"
"${TASK_ROOT}/build/test_gin_resource_alloc"

cd "${SOURCE_DIR}"
python setup.py bdist_wheel

echo "finish=$(date -u +%FT%TZ) sha=$(git rev-parse HEAD)"
