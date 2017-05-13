#!/bin/bash

files=`ls *controller*`

#echo $files

for f in $files
do
    echo $f
    grep "^[[:blank:]]*def " $f | grep -v '^#'
    
done

#grep "def" *controller*