#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Invalid input. Please use exactly one parameter. Entered $#"
    exit 1
fi

parameter="$1"
number_regex='^[+-]?[0-9]*[.,]?[0-9]+$'

if [[ "$parameter" =~ $number_regex ]]; then
    echo "Invalid input. Please use a text value."
    exit 1
fi

echo "The parameter value is: $parameter"
