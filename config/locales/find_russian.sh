#!/bin/bash

dir_to_search='../../app/'

#grep '[а-яА-Я]' `find -type f -name '*rb'`

#grep '[а-яА-Я]' `find $dir_to_search -type f -name '*rb'`

grep 'Точно' `find $dir_to_search -type f -name '*rb'`



#sed -i -e"s/:confirm => 'Точно?'/:confirm => t(:az_label_are_you_sure)/g" `find app/views/ -type f -name '*erb'`
