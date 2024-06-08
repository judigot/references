#!/bin/bash

PRODUCTION_DEPENDENCIES=(
    "axios"
)

DEV_DEPENDENCIES=(
    "prettier"
)

# Scenario 1
echo "Initial DEV_DEPENDENCIES:"
echo "${DEV_DEPENDENCIES[@]}"

# # Scenario 2: Append "axios" to PRODUCTION_DEPENDENCIES
PRODUCTION_DEPENDENCIES+=("axios")

echo "Updated PRODUCTION_DEPENDENCIES:"
echo "${PRODUCTION_DEPENDENCIES[@]}"
