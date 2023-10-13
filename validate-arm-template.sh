#!/bin/bash

RESOURCE_GROUP=$1
TEMPLATE_FILE_PATH=$2
TEMPLATE_PARAMETER_FILE_PATH=$3

# Validate the ARM template
az deployment group validate --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_FILE_PATH --parameters @$TEMPLATE_PARAMETER_FILE_PATH

# Check if the validation was successful
if [ $? -eq 0 ]; then
    echo "ARM Template validation passed."
else
    echo "ARM Template validation failed."
fi
