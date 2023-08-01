#!/bin/bash

# Switch to a working version of Java for this build
#sdk use java 11.0.19-tem

# Clear all results
rm -rf results
rm -rf comparisons
mkdir comparisons

# Run performance experiments with profiles
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --bazel --output-dir results/nonAbiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --bazel --output-dir results/abiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.2.1 --output-dir results/nonAbiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.2.1 --output-dir results/abiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.3-rc-2 --output-dir results/nonAbiChange/gradle-8.3-RC-1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.3-rc-2 --output-dir results/abiChange/gradle-8.3-RC-1

# Process results into comparisons
python3 fix-bench-csvs.py comparisons/bazel-and-gradle-8.2.1.csv results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv
python3 fix-bench-csvs.py comparisons/bazel-and-gradle-8.3-RC-1.csv results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv
python3 fix-bench-csvs.py comparisons/gradle-8.2.1-and-8.3-RC-1.csv results/abiChange/gradle-8.2.1-with-cc/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv
python3 fix-bench-csvs.py comparisons/bazel-and-gradle-8.2.1-and-8.3-RC-1.csv results/abiChange/bazel/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv
