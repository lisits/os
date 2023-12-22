#!/bin/bash

total_attempts=0
correct_attempts=0
incorrect_attempts=0
last_numbers=()
correct_numbers=()

while true; do
    # Generate a random number in the range [0, 9]
    secret_number=$((RANDOM % 10))

    # Prompt user for input
    read -p "Step $((total_attempts + 1)): Please enter number from 0 to 9 (q - quit): " user_input

    # Check if the user wants to quit
    if [ "$user_input" == "q" ]; then
        echo "Game over. Thank you!"
        break
    fi

    # Validate user input
    if ! [[ "$user_input" =~ ^[0-9]$ ]]; then
        echo "Error! Write correct number from 0 to 9"
        continue
    fi

    # Increment total attempts
    ((total_attempts++))

    # Check if the guess is correct
    if [ "$user_input" -eq "$secret_number" ]; then
        ((correct_attempts++))
        echo -e "\e[32mHit! My number $secret_number\e[0m"
        correct_numbers+=(1)
    else
        ((incorrect_attempts++))
        echo -e "\e[31mMiss! My number: $secret_number\e[0m"
        correct_numbers+=(0)
    fi

    # Update last numbers array
    last_numbers+=("$secret_number")
    if [ "${#last_numbers[@]}" -gt 10 ]; then
        unset 'last_numbers[0]'
        last_numbers=("${last_numbers[@]}")
        unset 'correct_numbers[0]'
        correct_numbers=("${correct_numbers[@]}")
    fi

    # Display statistics
    echo "Hit: $correct_attempts $((correct_attempts * 100 / total_attempts))%"
    echo "Miss: $incorrect_attempts $((incorrect_attempts * 100 / total_attempts))%"
    echo "Numbers: "

    index=0
    while [ "$index" -lt "${#last_numbers[@]}" ]; do
    num="${last_numbers[index]}"
    cor="${correct_numbers[index]}"

    if [ "$cor" -eq 1 ]; then
        echo -n -e "\e[32m$num\e[0m "  # Зеленый цвет для числа 1
    elif [ "$cor" -eq 0 ]; then
        echo -n -e "\e[31m$num\e[0m "  # Красный цвет для числа 0
    else
        echo "$num"
    fi

    ((index++))
    done
    echo ""
done