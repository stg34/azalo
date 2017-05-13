#!/bin/bash


str2find=">Удалить<"
str2replace="><%= t(:az_label_delete) %><"

grep "$str2find" $(find app/views/ -type f -name '*erb')

sed -i -e"s/$str2find/$str2replace/g"  $(grep -l "$str2find" $(find app/views/ -type f -name '*erb'))
