#!/bin/bash

FRUITS=("Apple" "Banana" "Kiwi" "Orange")

echo "First Fruit is : ${FRUITS[0]}"
echo "Second Fruit is : ${FRUITS[1]}"
echo "Third Fruit is : ${FRUITS[2]}"
echo "Fourth Fruit is : ${FRUITS[3]}"

${FRUITS[@]:2}
${FRUITS{1}:[@]}