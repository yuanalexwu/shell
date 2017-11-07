#!/bin/bash
# author: yuan.wu

# function func {
#     echo $[ $1 * $2 ]
# }

# if [ $# -eq 2 ]
# then
#     value=$(func $1 $2)
#     echo $value
# else
#     echo "Usage: ./function.sh a b"
# fi


# function addArray {
#     local sum=0
#     local newArray=$(echo "$@")
#     for value in ${newArray[*]}
#     do
#         sum=$[ $sum + $value ]
#     done
#     echo $sum
# }
# myArray=(1 2 3 4 5)
# args=$(echo ${myArray[*]})
# echo "The original array is: $args"
# result=$(addArray $args)
# echo "The result is: $result"


# function doubleArray {
#     local originArray=($(echo "$@"))
#     local newArray=($(echo "$@"))
#     local elemNum=$#
#     for (( i = 0; i < elemNum; i++ ))
#     {
#         newArray[$i]=$[ ${originArray[$i]} * 2 ]
#     }
#     echo "${newArray[*]}"
# }
# myArray=(1 2 3 4 5)
# args=$(echo ${myArray[*]})
# echo "Origin array is: ${args}"
# result=$(doubleArray $args)
# echo "Result array is: $result"


function factorial {
    if [ $1 -eq 1 ]; then
        echo 1
    else
        local tmp=$[ $1 - 1 ]
        local result=$(factorial $tmp)
        echo $[ $result * $1 ]
    fi
}
read -p "Enter a Number: " value
until [ $value -ge 1 ] 2> /dev/null
do
    echo "$value is not greater than 1"
    read -p "Enter a Number: " value
done
result=$(factorial $value)
echo "$value's factorial is: $result"