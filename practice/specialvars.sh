#!/bin/bash

echo "All arguments : $@"

echo "Number of arguments : $#"

echo "Script name : $0"

echo "Present working directory where script executed from : $PWD"

echo "Home directory : $HOME"

echo "process ID of current script : $$"

sleep 100 &
echo "Process ID of last background command : $!"