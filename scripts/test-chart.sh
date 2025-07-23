#!/bin/bash

# Chart testing script for local development
set -e

echo "🔍 Linting charts with Helm..."
helm lint ./cronjob-scale-down-operator

echo "✅ Helm lint passed!"

echo "🔍 Running chart-testing lint..."
ct lint --config ci/ct-config.yaml --all

echo "✅ Chart-testing lint passed!"

echo "🔍 Testing chart template rendering..."
helm template test-release ./cronjob-scale-down-operator > /tmp/rendered-templates.yaml

echo "✅ Template rendering passed!"

echo "🎉 All tests passed! The chart is ready for deployment."
