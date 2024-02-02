#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "$#" -ne 3 ]]
then
  echo "Usage: $0 <n-lower-bound> <n-upper-bound> <iters>"
  exit 1
fi

start=$1
end=$2
iters=$3

OUTPUT_DIR=benchmark-data.$(date +"%Y.%m.%d.%H-%M-%S")
mkdir -p "$OUTPUT_DIR"/fftw3 && mkdir "$OUTPUT_DIR"/rustfft && mkdir "$OUTPUT_DIR"/phastft

benchmark_phastft() {
    cargo clean && cargo build --release --examples

    for n in $(seq "$start" "$end"); do
        echo "running PhastFT benchmark for N = 2^${n}" && \
        for _ in $(seq 1 "$iters"); do
            ../target/release/examples/benchmark "${n}" >> "${OUTPUT_DIR}"/phastft/size_"${n}"
        done
    done
}

benchmark_rustfft() {
    cargo clean && cargo build --release --examples

    for n in $(seq "$start" "$end"); do
        echo "running RustFFT benchmark for N = 2^${n}" && \
        for _ in $(seq 1 "$iters"); do
            ../target/release/examples/rustfft "${n}" >> "${OUTPUT_DIR}"/rustfft/size_"${n}"
        done
    done
}

benchmark_rustfft
benchmark_phastft