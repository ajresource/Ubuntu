#!/bin/bash

#=================================================================================
#Title           :dmenu.sh
#Description     :This script will provide a menu base MENU.CONF
#Author          :Anjana Rupasinghege (AJ)
#Date            :201612-6
#Version         :1.0
#Usage           :bash
#Notes           :Menu is created using menu.conf
#Bash_version    :GNU bash, version 4.3.11(1)-release (x86_64-pc-linux-gnu)
#=================================================================================


######################## VARIABLES #############################################


MENU_CONF="menu.conf"
menu_selection_list=$(cat $MENU_CONF | grep menu_list | awk -F "\"" '{print $2}')
menu_selection_list_arr=($menu_selection_list)
arr_count=${#menu_selection_list_arr[@]}
counter=0
sel="k"
######################## END OF VARIABLES ######################################


######################## FUNCTIONS ##############################################
function colour-Red {
 echo -e "\033[31m"
}

function colour-Green {
 echo -e "\033[32m"
}

function colour-Reset {
 echo -e "\033[0m"
}

function ClearAll {

 for (( l=1; l<=$arr_count; l++))
 do
        let val$l=0
 done

}


function runMenuItems {
 let len=$arr_count-1
 for (( i=0; i<=$len; i++ ))
 do
        let j=$i+1
        runselecter="val"$j
        eval runselecter=\$$runselecter
        if [[ $runselecter -eq 1 ]]
        then
                echo "Running  ${menu_selection_list_arr[$i]}"
#               <Add Dynamic codes to rum the menu items. #

                sleep 1
        fi

 done
}



function listMenuItems {
 for i in $menu_selection_list
 do
        ((counter++))
         selecter="val"$counter
        eval selecter=\$$selecter
        if [[ $selecter -eq 1 ]]
        then
                echo -e "$counter) [\033[31mX\033[0m] $i"
        else
                echo "$counter) [ ] $i"
        fi
 done
}

######################### END OF FUCNITONS ###########################################

######################## TESTING PRE-REQUISITES ######################################

clear
echo "###############################################################################"

if [[ -f $MENU_CONF ]];
then
        echo "conf found, moving.."
else
        colour-Red
        echo "ERROR: menu.conf does not exists in the default location"
        colour-Reset
        read -p "Press any key to exit... " -n1 -s
        exit
fi



colour-Green
echo "Pre-requisites are complted, proceeding to the menu"
colour-Reset
echo "###############################################################################"

######################## END OF PRE-REQUISITES #############################################


################################## MAIN ####################################################

while :
do
        clear
        colour-Green
        echo "Dynamic Menu"
        echo "============"
        colour-Reset

        echo "Selection Menu"
        echo "--------------"


        counter=0
        listMenuItems
        echo
        read -n1 -r -p  "Select the menu by pressing the numbers, press r to run, c to clear, q to exit : " sel

        if [[ $sel =~ [[:digit:]] ]]
        then
                abc=val$sel
                eval test1=\$$abc
                #[[ $test1 -eq 1 ]] && let val$sel=0 || let  val$sel=1
                if [[ $test1 -eq 1 ]]
                then
                        let val$sel=0
                else
                        let val$sel=1
                fi

        fi

        if [[ $sel == "r" ]]
        then
                echo
                runMenuItems
                exit
        fi

        if [[ $sel == "c" ]]
        then
                echo
                ClearAll
        fi

        if [[ $sel == "q" ]]
        then
                echo
                echo "Exiting..."
                exit
        fi


done

################################## END OF MAIN ##################################################
                                                                                                             
