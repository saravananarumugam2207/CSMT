#! /bin/sh

# Developer : Saravanan A
# Purpose:	Using this script , could monitor the server like top process, FS,LVM

host=`hostname`
up=`uptime 2>/dev/null|awk '{print $2" since " $3 " " $4}'`
user_id=`id|cut -d"(" -f2|cut -d")" -f1`
os=`uname -a| awk '{sub(/^ /,"");print $4}'`
os_version=`uname -a | awk '{sub(/^ /,"");print $3}'`
# demidecode -t is not working on above 2. 
manufacture=` dmidecode 2>/dev/null | grep -A8 "System Information" 2>/dev/null | awk '/Manufacturer:/{sub(/^[ \t]+/,"");gsub(/Manufacturer:/,"");sub(/^ /,"");print $0}'`
product_name=` dmidecode 2>/dev/null | grep -A8 "System Information" 2>/dev/null| awk '/Product Name:/{sub(/^[ \t]+/,"");gsub(/Product Name:/,"");sub(/^ /,"");print $0}'`
sversion=` dmidecode 2>/dev/null | grep -A8 "System Information" 2>/dev/null| awk '/Version:/{sub(/^[ \t]+/,"");gsub(/Version:/,"");sub(/^ /,"");print $0}'`
sserial_no=` dmidecode 2>/dev/null | grep -A8 "System Information" 2>/dev/null| awk '/Serial Number:/{sub(/^[ \t]+/,""); gsub(/Serial Number:/,"");sub(/^ /,"");print $0}'`

ADMDIR="/usr/local/admintool"
VAR_DIR="$ADMDIR/var"
BIN_DIR="$ADMDIR/bin"
ETC_DIR="$ADMDIR/etc"
TMP_DIR="$ADMDIR/tmp"
LOGDIR="$VAR_DIR/logs"
HCDIR="$ADMDIR/hc"
ADMLOG="$LOGDIR/.admintool_cmd_`date "+%d%h%Y"`.log"
AUDLOG="$LOGDIR/.admintool_menu_`date "+%d%h%Y"`.log"

# AUDLOG="/var/log/admintool/admintool_log_`date "+%d%h%Y"`.log"
# ADMLOG="/var/log/admintool/run_cmd_log_`date "+%d%h%Y"`.log"
[[ ! -f $ADMLOG ]] && printf "%-25s %-20s %-20s\n" "Date" "User" "Command" >> $ADMLOG && chmod 0622 $ADMLOG
[[ ! -f $AUDLOG ]] && printf "%-25s %-20s %-20s\n" "Date" "User" "Menu option" >> $AUDLOG && chmod 0622 $AUDLOG

user=`who am i|awk '{print $1}'`
ts=`date "+%h %Y %H:%M:%S"`
eid=`id -un`
CANCEL=99
HELP=98
CPROMPT=97
EXIT=96
REFRESH=95
DASHBOARD=94
INERR=93
	stty erase 

function Get_odx
{
        od -t o1 | $AWK '{ for (i=2; i<=NF; i++)
                        printf("%s%s", i==2 ? "" : " ", $i)
                        exit }'
}
AWK=gawk
[ -x /bin/nawk ] && AWK=nawk
SCRWID=`tput cols`
SCRHIG=`tput lines`
tty_kf1=$(tput kf1 2>&1 | Get_odx)
tty_kf2=$(tput kf2 2>&1 | Get_odx)
tty_kf3=$(tput kf3 2>&1 | Get_odx)
tty_kf5=$(tput kf5 2>&1 | Get_odx)
tty_kf10=$(tput kf10 2>&1 | Get_odx)
tty_ent=$(echo | Get_odx)                      # Enter key
tty_kent=$(tput kent 2>&1 | Get_odx)
######Added by Amit 
tty_k0=$(tput k1 2>&1 | Get_odx)
tty_k1=$(tput k1 2>&1 | Get_odx)
tty_k2=$(tput k1 2>&1 | Get_odx)
tty_k3=$(tput k1 2>&1 | Get_odx)
tty_k4=$(tput k1 2>&1 | Get_odx)
tty_k5=$(tput k1 2>&1 | Get_odx)
tty_k6=$(tput k1 2>&1 | Get_odx)
tty_k7=$(tput k1 2>&1 | Get_odx)
tty_k8=$(tput k1 2>&1 | Get_odx)
tty_k9=$(tput k1 2>&1 | Get_odx)
tty_k10=$(tput k1 2>&1 | Get_odx)
tty_k11=$(tput k1 2>&1 | Get_odx)
tty_k12=$(tput k1 2>&1 | Get_odx)

f1="033 133 061 061 176"
f2="033 133 061 062 176 012"
f3="033 133 061 063 176 012"
f5="033 133 061 065 176 012"
f10="033 133 062 061 176 012"

tty_f1="033 133 061 061 176"
tty_f2="033 133 061 062 176"
tty_f3="033 133 061 063 176"
tty_f5="033 133 061 065 176"
tty_f10="033 133 062 061 176"

tty_c="143"
tty_C="103"
tty_d="144"
tty_D="104"
tty_f="146"
tty_F="106"
tty_h="150"
tty_H="110"
tty_r="162"
tty_R="122"
tty_q="161"
tty_Q="121"

####Added by Amit
tty_0="060"
tty_1="061"
tty_2="062"
tty_3="063"
tty_4="064"
tty_5="065"
tty_6="066"
tty_7="067"
tty_8="070"
tty_9="071"








t_c="143 012"
t_C="103 012"
t_F="106 012"
t_D="104 012"
t_r="162 012"
t_R="122 012"
t_q="161 012"
t_Q="121 012"
t_h="150 012"
t_H="110 012"

t_b="177 177"
t_B="177 012"


#### Modified by Amit############

t_0="060 012"
t_1="061 012"
t_2="062 012"
t_3="106 012"
t_4="104 012"
t_5="162 012"
t_6="122 012"
t_7="161 012"
t_8="121 012"
t_9="150 012"
t_10="110 012"















HEADER="<< Admintool v1.0 >>"
HDRWID="${#HEADER}"
(( HDRBEGIN = ( SCRWID - HDRWID ) / 2 ))

HEAD_1[0]="HostName       : `hostname`"
HEAD_1[1]="Kernel Version : `uname -r`"
HEAD_1[2]="Uptime         : $up"
HEAD_1[3]="Running as     : $user_id"
if [[ "$sserial_no" != "" ]]
then
HEAD_1[4]="Serial Number  : $sserial_no"
HEAD_1[5]="Version        : $sversion"
HEAD_2[4]="Product Name   : $product_name"
HEAD_2[5]="Manufacturer   : $manufacture"
fi
HEAD_2[0]="Load average   : `uptime | awk '{gsub(/[a-zA-Z]+, /,"\n");print}' | grep 'load average:' | awk '{gsub(/load average: /,""); sub(/^ /,""); print $0}'`"
HEAD_2[1]="Redhat Release : ` cat /etc/issue | head -1`"
HEAD_2[2]="System time    : `date` "
HEAD_2[3]="No.of.users    : `w | grep -v "FROM" | grep -v "load average" | wc -l`"
HEAD_ROWS=$((${#HEAD_1[@]}+${#HEAD_2[@]}))


lvm_version=`rpm -qa 2>/dev/null | grep -i ^lvm | head -1 | awk '{gsub(/-/," "); print $1 }'`
if [ ! -d /var/log/admintool ]
then
	mkdir -p  /var/log/admintool/ 2>/dev/null
	chmod 777 /var/log/admintool 
fi
		
# Dashboard
# 
# Memory usage > 90% : No
# PS usage > 5% : No
# FS usage > 80% : Yes
# Recent Errors : No
# rootvg mirror : No

dash_board ()
{
	# mem_val=`ps aux 2>/dev/null | awk '{prin  $4}'| sort -rn | head -1`
	mem_val=` ps aux 2>/dev/null | awk '{print  $4}'| sort -rn | head -1 | awk '{ gsub(/\./," "); print $1}'`
	 # mem_val=`ps aux 2>/dev/null | awk '{printf "%.0f\n" $4}'| sort -rn | head -1`
	if [[ $mem_val -gt 90 ]]
	then
		 DASH_BOARD[0]="Memory Usage > 90% : Yes"
	else
		  DASH_BOARD[0]="Memory Usage > 90% : No"
	fi

	ps_val=`top -b -n 1 2>/dev/null | sed -n '/PID/,${N;p}' | grep -v "PID" | awk '{gsub(/%/,"");print $9}' |  sort -rn | head -1  | awk '{ gsub(/\./," "); print $1}'`
	if [[ $ps_val -gt 5 ]]
	then
		 DASH_BOARD[1]="Paging Space Usage > 5% : Yes"
	else
		  DASH_BOARD[1]="Paging Space Usage > 5% : No"
	fi


	fs_val=`df -hP | grep -v "Use" | awk '{gsub(/%/,"");print $5}' | sort -r | head -1 | awk '{ gsub(/\./," "); print $1}'`
	if [[ $fs_val -gt 80 ]]
	then
		 DASH_BOARD[2]="FileSystem Usage > 80% : Yes"
	else
		 DASH_BOARD[2]="FileSystem Usage > 80% : No"
	fi
	sw_raid=`cat /proc/mdstat 2>/dev/null | grep "active"`
	if [[ $sw_raid != "" ]]
	then
		 DASH_BOARD[3]="Software Raid  : Yes"
	else
		 DASH_BOARD[3]="Software Raid : No"
	fi
	
	cluster_det=`clustat 2>/dev/null | grep -i "Status"`
	if [[ $cluster_det != "" ]]
	then
		 DASH_BOARD[4]="Cluster Service : Yes"
	else
		 DASH_BOARD[4]="Cluster Service : No"
	fi

	# printf "Recent Errors : No\n"
	# pvs_val=`vgdisplay rootvg`
	print_header
        MENU_ROW="15"
	if [ $d_flag -eq 0 ]
        then
                MENU_COL=$((SCRWID/2))
        else
                MENU_COL="1"
                MENU_ROW=$((MENU_ROW+1))
        fi
	echo -e "\033[1m"
	tput cup  $((MENU_ROW-2)) $MENU_COL ; echo "+---------------Dashboard---------------+"
	echo -e "\033[0m"
        tput cup  $((MENU_ROW-1)) $MENU_COL; echo "|                                       |"

       #  MENU_COL="0"
        DASH_BOARD_ATTR[0]="Memory usage > 90%:"
        ds=`date +%m%d`
        # tput cup  $((MENU_ROW-2)) $MENU_COL ; echo  "Dashboard"
        ha_state=Stable
        ha_state=Unstable
        for LINE in "${DASH_BOARD[@]}"
        do
	 tput cup $MENU_ROW $MENU_COL ;echo "| $LINE"
         tput cup $MENU_ROW $((MENU_COL+40)) ; echo "|"
               ((MENU_ROW=MENU_ROW+1))
        done
        tput cup  $((MENU_ROW)) $MENU_COL ; echo "+---------------------------------------+"
	 [[ ${d_flag} -eq 0 ]] && return
        tput civis
        sig_trap
        get_opt
        ret=$?
        case $ret in
                $HELP)
                # tool_help DASH_BOARD
                dash_board
                ;;
                $DASHBOARD)
                dash_board
                ;;
                $CANCEL)
                tput cnorm
                return
                ;;
                $EXIT)
                tput cnorm
                exit_admin
                ;;
                $REFRESH|*)
                dash_board
                ;;
        esac
	tput cnorm
}

sig_trap ()
{
        stty intr '' susp ''
        trap '' SIGINT SIGQUIT SIGTSTP
}


#####################################################
# manu function is for printing the menu options 
#####################################################
menu ()
{
        MENU_ROW="13"
        MENU_COL="13"
        MAIN_MENU[0]="1) Performance Management"
        MAIN_MENU[4]="2) Filesystems Usage & related task"
        MAIN_MENU[5]="3) Error report"
        MAIN_MENU[6]="4) Network management"
        MAIN_MENU[7]="5) Logical Volume Management"
        MAIN_MENU[8]="6) Multipath check"
        MAIN_MENU[9]="7) User Details"
        MAIN_MENU[10]="8) Cluster Details"
        # MAIN_MENU[13]="11) Run a command"
         MAIN_MENU[11]="r|R) Command Prompt"
        ITEMCNT="${#MAIN_MENU[@]}"
        for MENULINE in "${MAIN_MENU[@]}"
        do
                tput cup  $MENU_ROW $MENU_COL ; echo  "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
	printf "\n\n"
 
}

print_prompt ()
{
        ITEMCNT="${1}"
        tput cup  $((ITEMCNT+HEAD_ROWS+6)) 1 ; echo  "${prompt}"
}


performance_mgmt ()
{
	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "Performance Management"
	echo -e "\033[0m"
        PERF_MENU[0]="1) Top processes consuming CPU"
        PERF_MENU[1]="2) Top processes consuming Memory"
        PERF_MENU[3]="3) Overall CPU Utilization"
        PERF_MENU[4]="4) Overall Memory Utilization"
	PERF_MENU[5]="r) Command prompt"
 	ITEMCNT_PERF="${#PERF_MENU[@]}"
        for MENULINE in "${PERF_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
        # print_prompt $ITEMCNT_PERF
	printf "\n"
	printf "Enter the option : "
        audit_log Main_Menu Performance_management
        get_opt
        ret=$?
	case $ret in
		1)
			tput ed
			top_10_cpu
			audit_log 1 top_10_cpu
			performance_mgmt
			;;
		2) 
			tput ed
			top_10_mem
			audit_log 2 top_10_memory
			performance_mgmt
			;;
                3)
			tput ed
			over_all_cpu
			audit_log 3 Overall_CPU_Utilization
			performance_mgmt
			;;
                4)
			tput ed
			over_all_mem
			audit_log 4 Overall_Memory_Utilization
			performance_mgmt
			;;
                $CANCEL)
                	stty sane
	                return
        	        ;;
	        $HELP)
			MENU_ROW="15"
		        MENU_COL="10"
		        tput civis
		        help_item="${1}"
		        print_header
		        arr[0]=`grep -A8 "PERF_MGMT:" /$ETC_DIR/help`
		        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
		        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
		        get_opt
		        tput cnorm
			;;
		$DASHBOARD)
			dash_board
			;;
		$CPROMPT)  run_cmd;;
                $EXIT)
	                exit_admin
        	        ;;
                $REFRESH)
                	performance_mgmt
	                return
        	        ;;
                m|M|*)
               	menu
		;;

	esac

}

#####################################################
# error_report function is for printing the messages,maillog& secure log files
#####################################################
error_report ()
{
	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "Error Report"
	echo -e "\033[0m"
	printf "\n\n"
        ERR_MENU[0]="1) Mail log"
        ERR_MENU[1]="2) Messages log"
        ERR_MENU[3]="3) Server login details"
        ERR_MENU[4]="4) Secure log"
        ERR_MENU[5]="r) Command prompt"
 	ITEMCNT_ERR="${#ERR_MENU[@]}"
        for MENULINE in "${ERR_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
        # print_prompt $ITEMCNT_PERF
	printf "\n Enter your choice:"
	#read in
        get_opt
        ret=$?
	case $ret in
	1)
		# printline
		maillog_file=`find /var/log -mtime 0 2> /dev/null |grep "maillog"`
		if [[ "$maillog_file" == "" ]]
		then
			printf "No maillog files found\n"
		else

			error_str=`cat $maillog_file 2>/dev/null| grep "error" -i `
			if [[ "$error_str" == "" ]]
			then
				printf " No Errors found in the mail log\n"
			else
				# echo $error_str | less
				cat $maillog_file 2>/dev/null| grep "error" -i |less
			fi
		fi
		# printline
		printf "Press enter to continue"
		read in
		error_report
		;;
	2)
	# 	printline
		 maillog_file=`find /var/log -mtime 0  2> /dev/null |grep "messages"`
		# printf " Log files are $maillog_file \n"
		if [[ "$maillog_file" == "" ]]
		then
			printf "No Messages log  files found\n"
		else
			if [[ "$maillog_files" != "" ]]
			then
				error_str=`cat $maillog_file 2>/dev/null| grep "error" -i `
				if [[ "$error_str" == "" ]]
				then
					printf " No Errors found in the messages log\n"
				else
					# echo $error_str | less
					cat $maillog_file 2>/dev/null| grep "error" -i |less
				fi
			else
				printf " No Errors found in the messages log\n"
			fi
		fi
	 # 	printline
		printf "Press enter to continue"
		read in
		error_report
		;;
	3)
	# 	printline	
		printf "Enter the month name in mmm format ( Jan ) :   "
		read month_name
		file_names=`ls /var/log/wtmp*`
		touch -f /$TMP_DIR/last_file_op
		for i in $file_names
		do
			last -f $i >> /$TMP_DIR/last_file_op
		done
		 cat /$TMP_DIR/last_file_op | grep -wi "$month_name" | grep -v "wtmp" | grep -v "reboot" > /$TMP_DIR/rr
		if [[ ! -s /$TMP_DIR/rr ]]
		then
		#	printline
			printf "$month_name last log file is not available\n"
		else
		#	printline
			printf "User\tTerminal\tIP\t\tDate\tLogin\tLogout\tDuration \n"
		#	printline
			tput ed
			cat /$TMP_DIR/rr
		fi
		printf "\n"
		op=""
		rm -f  /$TMP_DIR/last_file_op 2> /dev/null
		rm -f /$TMP_DIR/rr 2>/dev/null
		# last|less
#		printline
		printf "Press enter to continue"
		read in
		error_report
		;;
	4)
#		printline
		 maillog_file=`find /var/log -mtime 0  2> /dev/null |grep "secure"`

		if [[ "$maillog_file" == "" ]]
		then
			printf "No secure log  files found\n"
		else
			error_str=`cat $maillog_file 2>/dev/null| grep "error" -i`
			if [[ "$error_str" == "" ]]
			then
				printf " No Errors found in the secure log\n"
			else
				# echo $error_str | less
				cat $maillog_file 2>/dev/null| grep "error" -i |less 
			fi
		fi
#		printline
		printf "Press enter to continue"
		read in
		error_report
		;;
                $CANCEL)
                stty sane
                return
                ;;
	   $HELP)
			MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A6 "ERROR_RPT:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;
		$DASHBOARD)
			dash_board
			;;
		 $CPROMPT) read in; run_cmd;;
                $EXIT)
                exit_admin
                ;;
                $REFRESH)
                error_report
                return
                ;;
                m|M|*)
               	menu
		;;
	 esac
	
}

#####################################################
# network_mgm function is for displaying network interfaces & routing table
#####################################################
network_mgm ()
{
	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "Network Management"
	echo -e "\033[0m"
	printf "\n\n"
        NET_MENU[0]="1) Display all the network interfaces"
        NET_MENU[1]="2) Display routing table"
        NET_MENU[2]="3) List Open Ports and Processes"
        NET_MENU[3]="r) Command prompt "
 	ITEMCNT_NET="${#NET_MENU[@]}"
        for MENULINE in "${NET_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
        # print_prompt $ITEMCNT_PERF
	printf "\n Enter your choice:"
        get_opt
        ret=$?
        case $ret in
           1)
		if [[ $user_id != "root" ]]
                then
#			printline
                       printf "You should be  root inorder to perform this action\n"
#			printline
                       moveon
			network_mgm
                else
			tput ed
        	# printf "\n_________________________________________________________________________________________________________\n\n"
	#	printline
		echo -e "\033[1m"
		# hed=`netstat -i | grep -wi "Interface" | awk '{print}'`
		hed="Network Interfaces"
                printf "\t\t\t $hed"
		echo -e "\033[0m"
        	# printf "\n_________________________________________________________________________________________________________\n\n"
	#	printline
               #  printf "%-12s %-12s %-16s %-10s %-17s %-10s %-12s \n" "Interface"  "IP" "Subnetmask" "Speed" "Auto-negotiation" "Duplex" "Link" 
		echo -e "\033[1m"
		printf "%-14s %-20s %-18s %-10s %-20s %-10s %-10s \n" "Interface"  "IP" "Subnetmask" "Speed" "Auto-negotiation" "Duplex" "Link"
		echo -e "\033[0m"
        	#printf "_________________________________________________________________________________________________________\n\n"
	#	printline
                for i in `ifconfig | grep -i 'Link encap:' | awk '{print $1}'  `
                do
                        IP=`ifconfig $i  2>/dev/null| grep -w 'inet addr'  | awk '{gsub(/addr:/,"");print $2}'`
                        SMASK=`ifconfig  $i 2>/dev/null| grep -wi Mask | awk '{gsub(/Mask:/,"");print $NF}'`
			SPEED=`ethtool $i 2>/dev/null| grep -wi speed | awk '{print $2}'`
			DUPLEX=`ethtool $i 2>/dev/null| grep -wi duplex | awk '{print $2}'`
			ANEG=`ethtool $i 2>/dev/null| grep -w 'Auto-negotiation' | awk '{print $2}'`
			LINK=`ethtool $i 2>/dev/null| grep -wi 'link detected' | awk '{print $3}'`
			stat="-"
			if [[ "$SPEED" == "" ]]
			then
				SPEED="-"
			fi
			if [[ "$DUPLEX" == "" ]]
			then
				DUPLEX="-"
			fi
			if [[ "$ANEG" == "" ]]
			then
				ANEG="-"
			fi
			if [[ "$IP" == "" ]]
			then
				IP="-"
			fi
			if [[ "$SMASK" == "" ]]
			then
				SMASK="-"
			fi
			if [[ "$LINK" == "" ]]
			then
				 LINK="-"
			fi
                       #  printf "%-12s %-12s %-16s %-13s %-17s %-10s %-12s \n" "$i"  "$IP" "$SMASK" "$SPEED" "$ANEG" "$DUPLEX" "$LINK"
			printf "%-12s %-20s %-20s %-15s %-17s %-10s %-10s \n" "$i"  "$IP" "$SMASK" "$SPEED" "$ANEG" "$DUPLEX" "$LINK"
			printf "\n"
                done

		audit_log "1 from Network Details" Network_interfaces
        	# printf "\n_________________________________________________________________________________________________________\n\n"
#		printline
                printf "Press enter to continue"
                read in
		network_mgm
		fi
                ;;
           2)
		
			tput ed
		# printline	
		echo -e "\033[1m"
		hed=`netstat -rn 2>/dev/null| grep -wi "routing" | awk '{print}'`
                printf "\t\t\t $hed"
		echo -e "\033[0m"
		# printline
        	# printf "_________________________________________________________________________________________________________\n\n"
		echo -e "\033[1m"
                netstat -rn  2>/dev/null| grep -v "routing" | head -1 2> /dev/null
		echo -e "\033[0m"
        	# printf "_________________________________________________________________________________________________________\n\n"
		# printline
                netstat -rn  2>/dev/null| grep -v "routing" | grep -vi "Destination" | awk '{print}' 2> /dev/null
		audit_log "2 from Network Details" Routing_Table
		# printline
                printf "Press enter to continue"
                read in
		network_mgm
                ;;
	3)
			tput ed
		echo -e "\033[1m"
		printf "List Open Ports and Processes"
		echo -e "\033[0m"
		# printline
		# echo -e "\033[1m"
		echo -e "\033[1m"
		printf "%-14s %-20s %-18s %-10s \n" "Processes"  "PID" "Port" "Status" 
		# printf "Processes \t PID \t Port \t Status"
		echo -e "\033[0m"
		# printline
		
		lsof -i TCP 2>/dev/null |fgrep LISTEN > /$TMP_DIR/lsof_op
		while read lines
		do
		process=`echo $lines  | awk '{ print $1 }'`
		pid=`echo $lines  | awk '{ print $2}'`
		port=`echo $lines | awk '{ print $6 }'`
		status=`echo $lines  | awk 'gsub(/\(\)/,"");{ print $9 }'`
		printf "%-12s %-20s %-20s %-15s \n" "$process"  "$pid" "$port" "$status"
		done < "/$TMP_DIR/lsof_op"
		rm -f /$TMP_DIR/lsof_op
		audit_log "3 from Network Details" List_open_ports
		# printline
                printf "Press enter to continue"
                read in
		network_mgm
                ;;
           $CANCEL)
               		 network_mgm
        	        return
                	;;
	   $HELP)
			 MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A5 "NET_MGMT:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;

	$DASHBOARD)
		dash_board
		;;
	$CPROMPT)  run_cmd;;	
           $EXIT)
	 		exit_admin
	                ;;
           $REFRESH)
               		 network_mgm
	 	         return
                	 ;;
            m|M|*)
                menu
                ;;
        esac

}

#####################################################
# top_10_cpu function is for displaying top process which consuming more CPU.
#####################################################
top_10_cpu ()
{
 	# printline
	echo -e "\033[1m"
	printf "\t\t\t Top Process consuming CPU\n\n"
	echo -e "\033[0m"
 	# printline
			while ( true )
			do
	                        printf "Enter Number of process to display: "
        	                read n 
					nodigits="$(echo $n | sed 's/[[:digit:]]//g')"
				if [[ "$n" == "" ]]
				then
					continue
				elif [[ "$n" == "q" ]]
				then
					return
				elif [ ! -z $nodigits ] ; then
				  	echo "Invalid number format! Only digits." >&2
					continue
				else 
					break
				fi
			done
	n=$(( n+1))	
	nn=$(( n-1))	
 	# printline
	echo -e "\033[1m"
	# This is to print the top command header in bold
	top -b -n 1 2>/dev/null | sed -n '/PID/,${N;p}' | head -1
	echo -e "\033[0m"
	# THis is to print the top command output
	top -b -n 1 2>/dev/null | sed -n '/PID/,${N;p}' | head -$n | tail -$nn
 	# top
 	# printline
        printf "Press enter to continue"
        read in

}

#####################################################
# over_all_cpu function is for finding over all CPU usage 
#####################################################
over_all_cpu ()
{
	# printline
	printf "\e[1m  \n\t\t\t Overall CPU Utilization \n\n"
        printf "\e[0m"
	# printline
        # printf "____________________________________________________________________________________________________\n\n"
        noofcpu=`cat /proc/cpuinfo 2>/dev/null | grep -i processor|wc -l`
        usage=`top -b -n 1 2>/dev/null | grep -i "%" | awk '{gsub(/us,/,"");print $2 }'| head -1`
        Zprocess=`top -b -n 1 2>/dev/null| grep -i "zombie" | awk '{gsub(/, +/,"\n");print}'| grep -wi "zombie" | awk '{print $1}'`
        # noofUsers=`w | wc -l` # will provide wrong output
	noofUsers=`w | grep -v "FROM" | grep -v "load average" | wc -l`
	# noofUsers=`w | grep -i "users," | awk '{ print $6 }'`
        printf "\e[1m No of Processors :   "
        printf "\e[0m"
        printf "\t $noofcpu \n \n"
        printf "\e[1m CPU Usage :   "
        printf "\e[0m"
        echo -e "\t $usage \n "
        printf "\e[1m No of Zombie Processes :  "
        printf "\e[0m"
        printf "\t $Zprocess \n \n"
        printf "\e[1m No of Users Logged In :  "
        printf "\e[0m"
        printf "\t $noofUsers \n \n"
	# we should use mpstat command only. command is not there so that using top cmd.
 #	top -b 2>/dev/null| awk '/Mem/{exit} {print} '
	# printline
	printf "Press enter to continue"
	read in
}

#####################################################
# top_10_cpu function is for displaying top process which consuming more memory.
#####################################################
top_10_mem ()
{
 	# printline	
	echo -e "\033[1m"
	printf "\n\t\t\t Top Memory consuming process \n\n"
	echo -e "\033[0m"
 	# printline
	while ( true )
	do
	        printf "Enter Number of process to display: "
	        read n 
		nodigits="$(echo $n | sed 's/[[:digit:]]//g')"
		if [[ "$n" == "" ]]
		then
			continue
		elif [[ "$n" == "q" ]]
		then
			return
		elif [ ! -z $nodigits ] ; then
		  	echo "Invalid number format! Only digits." >&2
			continue
		else 
			break
		fi
	done
 	# printline	
	echo -e "\033[1m"
  	ps aux 2>/dev/null| head -1; 
	echo -e "\033[0m"
	ps aux 2>/dev/null| grep -v "STAT" | sort -rnk4 | head -$n
	# printline
        printf "Press enter to continue"
        read in
}


#############################################
## This function is used to pause the script
#############################################
moveon ()
{
	echo ""
	echo "Press any key to continue"
	read moveon
}

####################################################
## This function is for Getting the VG Information
####################################################
get_vg_list ()
{
	vg=`vgs`
	if [[ "$vg" == "" ]]
	then
		printf "\t\t\t There is no VG\n"
	else
		vgs  2> /dev/null | grep -v "VFree"  > /$TMP_DIR/vgs_list
	# printline
	printf "\e[1m"
	printf "%-30s %-8s  %-8s %-8s %-15s %-12s %-40s \n" "VGName" "#PV" "#LV" "#SN" "Attr" "VSize" "VFree"
	printf "\e[0m"
	# printline
	while read lines
	do
			vgname=`echo $lines | awk '{ print $1 }'`
			nopv=`echo $lines | awk '{ print $2 }'`
			nolv=`echo $lines | awk '{ print $3 }'`
			nosn=`echo $lines | awk '{ print $4 }'`
			attr=`echo $lines | awk '{ print $5 }'`
			vsize=`echo $lines | awk '{ print $6 }'`
			vfree=`echo $lines | awk '{ print $7 }'`
			printf "%-30s %-8s  %-8s %-8s %-15s %-12s %-40s \n" "$vgname" "$nopv" "$nolv" "$nosn" "$attr" "$vsize" "$vfree"
	done < "/$TMP_DIR/vgs_list"
		rm -f /$TMP_DIR/vgs_list 2>/dev/null
	fi
}

####################################################
## This function is for Getting the VG Information
####################################################
get_pv_info ()
{
	pv=`pvs`
	if [[ "$pv" == "" ]]
	then
		printf "\t\t\t There is no PV \n"
	else
		pvs |grep -v Fmt 2> /dev/null > /$TMP_DIR/pvs_list
	# printline
	printf "\e[1m"
	printf "%-30s %-20s  %-12s %-12s %-12s %-12s  \n" "PVName" "VG" "FMT" "Attr"  "PSize" "PFree"
	printf "\e[0m"
	# printline
	while read lines
	do
			pvname=`echo $lines | awk '{ print $1 }'`
			vgname=`echo $lines | awk '{ print $2 }'`
			fmt=`echo $lines | awk '{ print $3 }'`
			attr=`echo $lines | awk '{ print $4 }'`
			vsize=`echo $lines | awk '{ print $5 }'`
			vfree=`echo $lines | awk '{ print $6 }'`
			printf "%-30s %-20s  %-12s %-12s %-12s %-12s  \n" "$pvname" "$vgname" "$fmt" "$attr"  "$vsize" "$vfree"
	done < "/$TMP_DIR/pvs_list"
	rm -f /$TMP_DIR/pvs_list 2>/dev/null
	fi
}

###################################################
## This function is for Getting Free PV Information
##################################################
list_free_pv ()
{
	pvdisplay 2>/dev/null| awk '/PV Name/;/Allocatable/{ print }' | sed '$!N;s/\n/ /' > /$TMP_DIR/pv_list
	chmod 644 /$TMP_DIR/pv_list
	if [ -s "/$TMP_DIR/pv_list" ]
	then
		printf "\e[1m"
		tput cup 21 17; echo "PV List" 
		tput cup 21 35; echo "Allocatable"
		printf "\e[0m"
			printf "\n"
		cat /$TMP_DIR/pv_list 2>/dev/null| sed -e 's/PV Name//g' | sed -e 's/Allocatable//g' | sed -e 's/(but full)//g' >/$TMP_DIR/free_pv
		cat /$TMP_DIR/free_pv 2>/dev/null
		rm -f /$TMP_DIR/pv_list 2>/dev/null
		rm -f /$TMP_DIR/free_pv 2>/dev/null
	else
		printf "\t\t\t There is no free PVs\n"
	fi
}


####################################################
## This Function is for Getting the UUID Information
####################################################
get_uuid_info ()
{
	
lvd=`lvdisplay 2>/dev/null|grep -i -v "no volume "`
if [[ "$lvd" != "" ]]
then
	printf "\e[1m"
	tput cup 21 15 ; echo "LV Name"
	tput cup 21 75 ; echo "UUID"
	printf "\e[0m"
	nx=23
	ux=23
	for LV in `lvdisplay 2>/dev/null|grep -i "lv name"| awk '{print $3}'`
	do
		# Display the disk UUID Info
		UUID=`blkid -s UUID $LV 2>/dev/null ` 
		lvname=`echo "$UUID" | awk '{gsub(/UUID=\"/,"");gsub(/\:/,"\t\t\t");gsub(/\"/,"");print $1}'`
		lv_uuid=`echo "$UUID" | awk '{gsub(/UUID=\"/,"");gsub(/\:/,"\t\t\t");gsub(/\"/,"");print $2}'`
		tput cup $nx  12 ; echo "$lvname"
		tput cup $ux  60 ; echo "$lv_uuid"
		# this will prevent to overwrite the data in the same line & column.
		nx=$(( $nx + 2 ))
		ux=$(( $ux + 2 ))
		printf "\n"
	done
else
	tput cup 21 15 ; echo "No Logical Volume found"
	
fi
}

####################################################
# Listing the LVS
####################################################
list_lvs ()
{
	lvd=`lvdisplay 2>/dev/null|grep -i -v "no volume "`
        if [[ "$lvd" != "" ]]
        then
                printf "\e[1m"
                printf "\n\t List of Logical Volume\n"
                printf "\n\n"
                printf " %-22s %-22s \n" "                  LV Name "  "                      LV Size"
                printf "\e[0m"
                #tput cup 21 30 ; echo "LV Name"
                #tput cup 21 60; echo "LV Size"
                lvdisplay 2>/dev/null| sed -e '/LV Name\|LV Size/!d '| awk '{gsub(/LV Name/,"");gsub(/LV Size/,"");print}'| sed '$!N;s/\n/ /'
                printf "\n\n"

        fi

}


####################################################
# List the available LVS
####################################################
list_mount ()
{
	 lv=`lvs`
        if [[ "$lv" != "" ]]
        then
                printf "\e[1m"
                printf " %-22s %-20s \n" "                LV Name "  "                        Mounted on"
                printf "\e[0m"
                #tput cup 21 30 ; echo "LV Name"
                #tput cup 21 60; echo "Mounted on"
                # List the mounted LVs.
                mount 2>/dev/null| grep "`lvs | awk '{print $1}'`"      | awk '{print "\t\t" $1 "\t\t\t" $3 }'
                # List the lvs which is not mounted  
                lvs 2>/dev/null| awk '{print $1}' | grep -v "\-`mount|awk '{print $1;gsub(/.*-/,"");print $1}'`" | awk '{print "\t\t" $1 "\t\t\t\t" "Not mounted"}'| grep -v "LV" |awk '{print}'
                 printf "\n\n"
                fi

}

####################################################
# Removing the VG
# Before removing the VG , hve to deactivate that VG.
# VG should not contain any LVS
####################################################
remove_vg ()
{
# printf "\t\t\t Volume Group Remove\n"
while ( true )
do
	printf "Enter VG Name: "
	read NewVgName
	if [[ "$NewVgName" == "q" ]]
	then
		printf "Exiting from Remove VG's\n"
		return
	else
		vg_check=`vgs 2>/dev/null| grep -i $NewVgName` 
		if [[ "$vg_check" == "" ]]   #### Check if VG Name is already in use #####
		then
        		printf "$NewVgName VG does not exists..\n"
			continue
		else
			break
		fi
	fi
done
	npv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $2}'`
	nlv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $3}'`
	if [[ $nlv -gt 0 ]]
	then
		printf "$nlv LV's are there. can not remove $NewVgName VG \n"
	else
		vgremove $NewVgName 2>/dev/null
		if [[ $? -eq 0 ]]
		then
			printf "$NewVgName VG Removed successfully\n"
		else
			printf "$NewVgName VG is not  Removed \n"
		fi
	fi
}

####################################################
# Reduce the VG
####################################################
reduce_vg ()
{
#echo -e "\033[1m"
#printf "\t\t\t Reduce the Volume Group\n"
#echo -e "\033[0m"
while ( true )
do
	printf "Enter PV Name : "
	read pvname
	if [[ "$pvname" == "" ]]
	then
		printf "PV Name should not be empty\n"
	else
		if [[ "$pvname" == "q" ]]
		then
			printf " Exiting from Reduce VG's\n"
			return
		else
			pname=`pvs 2>/dev/null| grep -v PSize | awk '{ print $1 }'|grep "$pvname"`
			if [[ "$pname" == "" ]]    #### check if PV exist
	        	then
        	        	printf " $pvname  PV does not exists \n"
				continue
			else
				break
			fi
		fi
	fi
done

while ( true )
do
	printf "Enter VG Name: "
	read VgName
	vg_check=`vgs 2>/dev/null| grep -i $VgName` 
	if [[ "$vg_check" == "" ]]   #### Check if VG Name is already in use #####
	then
        	printf "$VgName VG does not exists\n"
		continue
	else
		if [[ "$VgName" == "q" ]]
		then
			printf "Exiting from Reduce VG's\n"
			return
		else
			break
		fi
	fi

done	
	npv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $2}'`
	nlv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $3}'`
	printf "Are you sure want to reduce Volume Group [y/n]?:  "	
	read confrm
	if [[ "$confrm" == "y" ]]
	then
		if [ $npv -eq 1 ]
		then
			printf "Only one PV is available. Can not reduce the VG..\n"
		else
			vgreduce $VgName $pvname  2> /dev/null
			if [ $? -eq 0 ]
			then
				printf " $VgName VG reduced successfully..\n"
			else
				printf " $VgName VG not reduced ..\n"
			fi
		fi		
	elif [[ "$confrm" == "n" || "$confrm" == "" ]]
	then
		printf "Reduce VG is not confirmed.. Exiting from REduce VG \n"
	fi		
}
###################################
# creating Volume group
###################################
create_vg ()
{
# printf "\t\t\t Creating Volume Group \n"
while ( true )
do
	printf "Enter PV Name : "
	read pvname
	if [[ "$pvname" == "" ]]
	then
		printf "PV Name should not be empty\n"
	else
		if [[ "$pvname" == "q" ]]
		then
			printf "Exiting from Create VG's\n"
			return
		else
			pname=`pvs 2>/dev/null| grep -v PSize | awk '{ print $1 }'|grep "$pvname"`
			if [[ "$pname" == "" ]]    #### check if PV exist
	        	then
        	        	printf " $pvname  PV does not exists , Please create a new PV\n"
				continue
			else
				break
			fi
		fi
	fi
done

while ( true )
do
	printf "Enter VG Name: "
	read NewVgName
	vg_check=`vgs 2>/dev/null| grep -i $NewVgName` 
	if [[ "$vg_check" != "" ]]   #### Check if VG Name is already in use #####
	then
        	printf "$NewVgName VG already exists,Pick a new VGName\n"
		continue
	else
		if [[ "$NewVgName" == "q" ]]
		then
			printf "Exiting from Create VG's\n"
			return
		else
			break
		fi
	fi	
done
			VGName=`pvs 2>/dev/null|grep -i $pvname | awk '{print $2}'`    ####Check if PV is Allocatable/Free to be assigned to a VG ########
			allocatable=`pvdisplay $pvname 2>/dev/null| grep -i "Allocatable"|awk '{print $2}'`		
			if [[ "$allocatable" == "yes" ]]
			then
				printf "$pvname is already part of $VGName\n"
			else
				echo $pvname is Free
				vgcreate $NewVgName $pvname  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$NewVgName VG create successfully\n"
				else
					printf "$NewVgName VG has not created..\n"
				fi
			fi
}

###################################
# Extending the VG
###################################
extend_vg ()
{
# printf "\t\t\t Extending Volume Group \n"
while ( true )
do
	printf "Enter PV Name : "
	read pvname
	if [[ "$pvname" == "q" ]]
	then
		printf "Exiting from Extend VG \n"
		return
	else
		pname=`pvs 2>/dev/null| grep -v PSize | awk '{ print $1 }'|grep "$pvname"`
	        if [[ "$pname" == "" ]]    #### check if PV exist
        	then
                	printf " $pvname  PV does not exists , Please create a new PV\n"
	                continue
        	else
                	break
	        fi
	fi
done
while ( true )
do
	printf "Enter VG Name: "
	read VgName
	vg_check=`vgs 2>/dev/null| grep -i $VgName` 
	
	if [[ "$VgName" == "" ]]   #### Check if VG Name is already in use #####
	then
        	printf "Plz Enter a Valid VGName\n"
		continue
	elif [[ "$VgName" == "q" ]]
	then
			printf " Exiting from Extending VG's\n"
			return
	elif [[ "$vg_check" == "" ]]
	then
		printf "VG Does not exits\n"
		continue
	else
			break
	fi
	
			####Check if PV is Allocatable/Free to be assigned to a VG ########
		
			allocatable=`pvdisplay $pvname 2>/dev/null| grep -i "Allocatable"|awk '{print $2}'`		
			if [[ "$allocatable" == "yes" ]]
			then
				printf "$pvname is already part of a Volume Group \n"
				continue
			else
				echo $pvname is Free
				break
			fi
done
				vgextend  $VgName $pvname  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$VgName VG extended  successfully\n"
				else
					printf "$VgName VG is not extended..\n"
				fi
}

###################################
# Creating LV
###################################
create_lv ()
{
# 	echo -e "\033[1m"
# 	printf "\t\t\t Creating Logical Volume \n"
# 	echo -e "\033[0m"
	list_lvs
	while ( true )
	do	
		printf "Enter VG Name : "
		read vgname
		if [[ "$vgname" == "" ]]
		then
			printf "VG Name should not be empty\n"
			continue
		else		
			if [[ "$vgname" == "q" ]]
			then
				printf "Exiting from Create LV\n"
				return
			else
				vg_check=`vgs 2>/dev/null|grep -w "$vgname" | awk '{ print $1}'`
				if [[ "$vgname" != "" ]]
				then
					if [[ "$vg_check" == "" ]]
					then
						printf "$vgname VG does not exists\n"
						continue
					else
						break
					fi		
				fi			
			fi
		fi
	done
	while ( true )
	do
		printf "Enter LV Name : "
		read lvname
		lv_check=`lvs 2>/dev/null| grep -v LV |grep -i "$lvname"`
		if [[ "$lvname" == "" ]]
		then
			printf "LV Name should not be empty\n"
			continue
		else
			if [[ "$lvname" == "q" ]]
			then
				printf "Exiting from create LV \n"
				return
			else
				if [[ "$lv_check" != "" ]]
				then
					printf "$lvname name already exists \n"
					continue
				else
					break
				fi
			fi
		fi
	done
	while ( true )
        do
                printf "Enter the Size of LV in units [eg 10 M/10 G] :  "
                read lvsize                          ################ New Size of LV##############
                if [[ "$lvsize" == "" ]]
                then
                        printf "Size should not be Empty\n"
                        continue
                else
			if [[ "$lvsize" == "q" ]]
			then
				printf "Exiting from Creating LV\n"
				return
			else
				r_unit=`echo $lvsize|grep -i -w "[mG]"`
	                        r_size=`echo $lvsize | awk '{ sub (/[mMgG]/,"");print $1}'`
        	                if [[ "$r_size" == "0" ]]
                	        then
                        	        printf " Please enter the Non zero size \n"
                                	continue
	                        else
        	                        dec=`echo $lvsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
                	                if [[ "$dec" != "" ]]
                        	        then
                                	        printf "  Size should not be decimal. Plz enter the rounded size\n"
                                        	continue
	                                else
        	                                if [[ "$r_unit" == "" ]]
                	                        then
                        	                        printf "Please enter the size in units [M/G] \n"
                                	                continue
                                        	else
                                                	nlvsize=`echo $lvsize | awk '{ sub (/ /,""); print $1 }'`
        	                                        break
                	                        fi
                        	        fi
	                        fi
        	        fi
		fi
        done
	while ( true )
	do
		printf "Enter the mount point : "
		read lvmount
		lvmount_check=`cat /etc/fstab 2>/dev/null|awk '{print $2}' | grep -w $lvmount`
		if [[ "$lvmount_check" != "" ]]
		then
			printf "Mount point is already exits \n"
			continue
		else
			if [[ "$lvmount" == "q" ]]
			then
				printf "Exiting from Creating LV\n"
				return
			else
				check_lv=`echo $lvmount | grep '^/'`
				if [[ "$check_lv" == "" ]]
				then
					printf " Mount point should start with /\n"
					continue
				else
					break
				fi
			fi							
		fi
	done
	free_size=`vgdisplay $vgname 2>/dev/null| grep -i "FREE  PE" | awk '{print $7 $8}'`	
	printf "Free space available on $vgname is $free_size\n"
	printf "Are you sure want to create LV [y/n] ?:  "
	read confrm
	if [[ "$confrm" == "y" ]]
	then
		lvcreate -L $nlvsize -n $lvname $vgname  2> /dev/null
		if [ $? -eq 0 ]
		then
			printf " Logical volume created successfully\n";
			newlvname="/dev/$vgname/$lvname"
			printf "New LV name is $newlvname\n"
			echo "Creating file system..\n"
			mke2fs -j $newlvname  2> /dev/null
			if [ $? -eq 0 ]
			then
				# Creating the mount point directory
				mkdir $lvmount
				echo "Mounting the $lvmount ..\n"
				mount $newlvname $lvmount  2> /dev/null
				if [ $? -eq 0 ]
				then
					echo " Completed....."
				else
			 		printf "Issue with the mounting FS\n"
				fi
			else
				printf " Issue with creating FS\n"
			fi	
		else
			printf "LV creation is not success \n"		
		fi
	elif [[ "$confrm" == "n" || "$confrm" == "" ]]
	then
		printf "LV creation not confirmed.. Exiting from Creating LV \n"
	fi					
}

###################################
# extending the LV
###################################
extend_lv ()
{
	#echo -e "\033[1m"
	#printf "\t\t\t Extending Logical Volume \n"
	#echo -e "\033[0m"
	list_lvs
        while ( true )
        do
                printf "Enter  full LV Name  starts with /: "
                read lvname
		if [[ "$lvname" == "" ]]
		then
			printf "LV Name should not be Empty\n"
			continue
		fi
		if [[ "$lvname" == "q" ]]
		then
			printf "Exiting from Extend LV\n"
			return
		else
			lv_check=`lvdisplay 2>/dev/null| grep "$lvname" | awk '{print $3}'`
			check_fs=`echo $lvname | grep '^/'`
			if [[ "$check_fs" == "" ]]
	                then
        	                printf " LV name should start with /\n"
                	        continue
			fi
        	        if [[ "$lv_check" == "" ]]
                	then
                		printf "$lvname name does not exists \n"
        	                continue
                	else
                        	break
	                fi
		fi
	done
	while ( true )
        do
                printf "Enter the Size of LV in units [eg 10 M/10 G] :  "
                read lvsize                          ################ New Size of LV##############
                if [[ "$lvsize" == "" ]]
                then
                        printf "Size should not be Empty\n"
                        continue
                else
			if [[ "$lvsize" == "q" ]]
			then
				printf "Exiting from Extend LV\n"
				return
			else
        	                r_unit=`echo $lvsize|grep -i -w "[mG]"`
                        r_size=`echo $lvsize | awk '{ sub (/[mMgG]/,"");print $1}'`
                        if [[ "$r_size" == "0" ]]
                        then
                                printf " Please enter the Non zero size \n"
                                continue
                        else
                                dec=`echo $lvsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
                                if [[ "$dec" != "" ]]
                                then
                                        printf "  Size should not be decimal. Plz enter the rounded size\n"
                                        continue
                                else
                                        if [[ "$r_unit" == "" ]]
                                        then
                                                printf "Please enter the size in units [M/G] \n"
                                                continue
                                        else
                                                nlvsize=`echo $lvsize | awk '{ sub (/ /,""); print $1 }'`
                                                break
                                        fi
                                fi
                        fi
                fi
	fi
        done
        printf "Are you sure want to Extend LV [y/n] ?:  "
        read confrm
        if [[ "$confrm" == "y" ]]
        then
		#echo "lvextend -L +$nlvsize $lvname"
	        lvextend -L +$nlvsize  $lvname  2> /dev/null
        	if [ $? -eq 0 ]
	        then
        	        printf " Logical volume extended successfully\n";
			# Resizing the FS..
			resize2fs $lvname   2> /dev/null	
			if [ $? -eq 0 ]
			then
				printf " $lvname FS resized successfully\n"
			else
				printf "Issue with $lvname FS resizing...\n"
			fi
       		 else
                	printf "LV Extend is not success \n"
	        fi
        elif [[ "$confrm" == "n" || "$confrm" == "" ]]
        then
                printf "LV Extension not confirmed.. Exiting from Extending LV \n"
	fi
}

#########################################
# Removing Lv
########################################
remove_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Removing the LV \n"
#	echo -e "\033[0m"

	list_lvs
	while ( true )
	do
		printf "Enter  full LV Name  starts with /: "
                read lvname
                if [[ "$lvname" == "" ]]
                then
                        printf "LV Name should not be Empty\n"
                        continue
		else	
			if [[ "$lvname" == "q" ]]
			then
				printf "Exiting from Delete LV\n"
				return
			else
	        	        lv_check=`lvdisplay 2>/dev/null| grep -w "$lvname" | awk '{print $3}'`
	                	check_fs=`echo $lvname | grep '^/'`
		                if [[ "$check_fs" == "" ]]
        		        then
                		        printf " LV Name should start with /\n"
                        		continue
		                fi
        		        if [[ "$lv_check" == "" ]]
                		then
                        		printf "$lvname name does not exists \n"
	        	                continue
        	        	else
                	        	break
		        	fi
			fi
		fi
	done
	lvm=`echo $lvname`
	mount_fsname=`echo $lvname | awk '{gsub(/.*\//,""); print $1}'`
	mount_point=`mount 2>/dev/null| grep  "$mount_fsname" | awk '{print $3 }'`
	if [[ "$lvm" == "" ]]
	then
		printf " Given $lvname does not exists \n"	
	else
		printf " Are you sure want to remove $lvm  LV [y/n]? : "	
		read confrm
		if [[ "$confrm" == "y" ]]
		then
			# Here no need to check if only the mounted FS should be mount. reason is, before removing the 
			# FS checking FS is exists or not uisng the mount command. only mounted FS only will come there
			fcheck=`echo $lvname|awk 'gsub("/"," "); {print  $3}'`
		        fsname_check=`mount 2>/dev/null|grep "$fcheck"`
		        if [[ "$fsname_check" == "" ]]
		        then
                		printf "$lvname is not mounted , deleting $lvname  \n"
			else
				printf "Unmounting the $lvm LV ...\n"
				umount $lvm  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf " $lvm unmounted successfully\n"
					unmounted_flag=1	
				else
					printf "Issue with unmounting $lvm LV\n"
				fi
			fi
					# removing the LV
				lvremove $lvm	  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$lvm LV removed successfully\n"
				else
					 printf " $lvm LV is not removed\n"
					if [[ "$unmounted_flag" == "1" ]]
					then
					     	mount $lvm $mount_point  2> /dev/null
					fi
				fi
		elif [[ "$confrm" == "n" || "$confrm" == ""  ]]
		then
			printf " LV deletion has not confirmed...Exiting from Remove LV\n"
		fi
	fi
}

############################################
# Reducing the LV
############################################
reduce_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Reducing the  LV \n"
#	echo -e "\033[0m"
	list_lvs
	
	while ( true )
	do
		printf "Enter Full  LV Name  starts with /: "
                read lvname
                if [[ "$lvname" == "" ]]
                then
                        printf "LV Name should not be Empty\n"
                        continue
                fi
		if [[ "$lvname" == "q" ]]
		then
			printf "Exiting from Reduce LV \n"
			return
		else
                lv_check=`lvdisplay 2>/dev/null| grep -w  "$lvname" | awk '{print $3}'`
                check_fs=`echo $lvname | grep '^/'`
                if [[ "$check_fs" == "" ]]
                then
                        printf " FS name should start with /\n"
                        continue
                fi
                if [[ "$lv_check" == "" ]]
                then
                        printf "$lvname name does not exists \n"
                        continue
                else
                        break
                fi
	fi
	done
	lvm=`echo $lvname`
	mount_fsname=`echo $lvname | awk '{gsub(/.*\//,""); print $1}'`
	mount_point=`mount 2>/dev/null| grep  "$mount_fsname" | awk '{print $3 }'`
	current_lvsize=`lvdisplay $lvname 2>/dev/null| grep -i "LV Size" | awk '{print $3 " " $4}'`
	current_unit=`echo $current_lvsize | awk '{print $2}'`
	current_size=`echo $current_lvsize | awk '{print  $1}'`
	# current_size=`printf "%.0f\n" "$current_fsize"`
	# echo "Current Size is :- .. " $current_size
	# current_size=`echo $current_lvsize | awk '{printf "%.0f\n"  $1}'`
	while ( true )
	do
		printf "Enter the New Desired Size of LV in units [eg 10 M/10 G] :  "
		read rsize                          ################ New Size of LV##############
		if [[ "$rsize" == "" ]]
		then
			printf "Size should not be Empty\n"
			continue
		else
			if [[ "$rsize" == "q" ]]
			then
				printf "Exiting from Reducing LV\n"
				return
			else
			r_unit=`echo $rsize|grep -i -w "[mG]"`
        	       	r_size=`echo $rsize | awk '{ sub (/[mMgG]/,"");print $1}'`
                	if [[ "$r_size" == "0" ]]
	                then
        	                printf " Please enter the Non zero size \n"
                	        continue
	                else
				dec=`echo $rsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
				if [[ "$dec" != "" ]]
				then
					printf "  Size should not be decimal. Plz enter the rounded size\n"
					continue
				else
	        	                if [[ "$r_unit" == "" ]]
        	        	        then
                	        	        printf "Please enter the size in units [M/G] \n"
                                		continue
		                        else
						# printf "Current unit is  \t : $current_unit .. given unit \t : $r_unit\n"
        		                        nrsize=`echo $rsize | awk '{ sub (/ /,""); print $1 }'`
						# both current & given units are same then
						r_unit=`echo $r_unit | awk '{ print $2 }'`
						# printf "Current unit .. $current_unit  R_unit is .. $r_unit\n"
						if [[ `echo $current_unit | grep -i "$r_unit"` != "" ]]
						then
							# reduce_size=$(( current_size - r_size ))
							# reduce_size=echo echo $current_size - echo $r_size|bc
							reduce_size=`echo "$current_size-$r_size"|bc`
							reduce_unit="$r_unit"
							# printf "Roselin\n"
							# echo $reduce_size $reduce_unit
							# printf "Roselin\n"
						elif [[ `echo $current_unit | grep -i "G"` != "" && "$r_unit" == "M" ]] # given size is M & current size is GB 
						then
							# size=$((current_size * 1024 ))
							#  reduce_size=$((size - r_size ))				
							# size=echo  echo $current_size *1024|bc
							# reduce_size=echo echo $size - echo $r_size|bc
							size=`echo "$current_size*1024"|bc`
							reduce_size=`echo "$size-$r_size"|bc`
							reduce_unit="M"
						elif [[ "$current_unit" == "MB" && "$r_unit" == "G" ]]
						then
							printf " Current LV size is in MB. Given new size is in GB. can not do reduce LV.\n"
							return							
						else
							printf " Else part \n"
						fi
                        		        break
	                        	fi
	        	        fi
			fi
		fi
	fi
	done
	       printf " Are you sure want to reduce $lvm  LV [y/n]? : "
       	       read confrm
	       if [[ "$confrm" == "y" ]]
               then
			fcheck=`echo $lvname|awk 'gsub("/"," "); {print  $3}'`
		        fsname_check=`mount 2>/dev/null |grep "$fcheck"`
		        if [[ "$fsname_check" == "" ]]
		        then
               		       printf "$lvname is not mounted , reducing the $lvname \n"
			else
                	        printf "Unmounting the $mount_point LV ...\n"
				umount $lvm  2> /dev/null
        		        if [ $? -eq 0 ]
                		then
                        	        printf " $mount_point  unmounted successfully\n"
					unmount_flag=1
					# reduce the FS residing on the LV
					e2fsck -f $lvm  2> /dev/null
					if [ $? -eq 0 ]
                                        then
						printf " $lvm e2fsck executed successfully..\n "
						# resize the filesystem on the logical volume 
						resize2fs $lvm $nrsize  2> /dev/null
						if [ $? -eq 0 ]
						then
							printf " $lvm resize2fs executed successfully..\n"					
							# Reduce the logical volume 
						else
							printf " $lvm resize2fs issues are there..\n"
							if [[ "$unmount_flag" == "1" ]]
							then
								# printf "Mounting $mount_point\n"
								mount $lvm $mount_point	  2> /dev/null
							fi
						fi

					else
						printf " $lvm e2fsck issues are there..\n"
					fi
        	                else
                	               	printf "Issue with unmounting $mount_poin LV\n"
			 	fi	
			fi
					finale_size=`echo $reduce_size  $reduce_unit |  awk '{ sub (/ /,""); print $1 }'`
					# printf "Reduce Size :- $reduce_size \n"
					# printf "Reduce Unit :- $reduce_unit \n"
					# printf "Finale size in reduce lv $finale_size \n"
					# printf " lvreduce -L -$finale_size  $lvm \n"
					lvreduce -L -$finale_size  $lvm  2> /dev/null
	                       	        if [ $? -eq 0 ]
        	                       	then
	          	        	     printf "$lvm LV reduced by $rsize successfully\n"
		                        else
                		               printf " Issue with reducing  $lvm LV by $rsize size\n"
						
							if [[ "$unmount_flag" == "1" ]]
							then
								mount $lvm $mount_point	  2> /dev/null
							fi
		                        fi
	        elif [[ "$confrm" == "n" || "$confrm" == ""  ]]
        	then
                        printf " Reduce LV has not confirmed...Exiting from Reduce LV\n"
	        fi
}

############################################
# mounting the FS ..
############################################
fs_mount ()
{
	list_mount
	while ( true )
	do
		printf "Enter the FS Name : "
		read fsname
		if [[ "$fsname" == "q" ]]
		then
			printf "Exiting from Mounting FS..\n"
			return
		else
			check_fs=`echo $fsname | grep '^/'`
			fs_check=`lvdisplay $fsname 2>/dev/null`
		        if [[ "$check_fs" == "" ]]
        		then
        			printf " FS name should start with /\n"
	        	        continue
			elif [[ "$fs_check" == "" ]]
			then
				printf "$fsname FS does not exits \n" 
				continue
			else
        		       break
		         fi
		fi
	done
	mount_fsname=`echo $fsname | awk '{gsub(/.*\//,""); print $1}'`
	fsname_check=`mount 2>/dev/null|grep "$mount_fsname"`
	if [[ "$fsname_check" != "" ]]
        then
                printf "$fsname is already in mounted \n"
        else
		while ( true )
		do
			printf "Enter the mount point : "
			read mount_point
			if [[ "$mount_point" == "" ]]
			then
				printf "quiting from mount FS..\n"
				return
			else
			mountpoint_check=`echo $mount_point | grep '^/'`
			if [[ "$mountpoint_check" == "" ]]
			then
				printf " Mount point should start with /\n"
				continue
			else
				break
			fi
		fi	
		done
		if [ ! -d "$mount_point" ]
		then
			printf " $mount_point doest not exists. want to create it [y/n]?: "
			read confrm
			if [[ "$confrm" == "y" ]]
			then
				mkdir -p $mount_point 2>/dev/null
			elif [[ "$confrm" == "n" || "$confrm" == "" ]]
			then
				printf " Creating $mount_point mount point is not confirmed.. \n"
				printf "Exiting from Mount FS..\n"
				return
			fi
		fi
	
		printf "Are you sure want to mount $fsname [y/n]?: "
                read mconfrm
      		if [[ "$mconfrm" == "y" ]]
                then
    		        mount $fsname $mount_point  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$fsname mounted successfully\n"
				else
					printf " $fsname is not mounted..\n"
				fi
		         elif [[ "$mconfrm" == "n" || "$mconfrm" == "" ]]
		         then
                       		printf " Mounting FS is not confirmed...\n"
		          fi
	fi		
}
################################
# unmounting the FS..
################################
fs_unmount ()
{
	list_mount
	while ( true )
        do
                printf "Enter the FS Name : "
                read fsname
		if [[ "$fsname" == "q" ]]
		then
			printf "Exiting from Unmounting the FS \n"
			return
		else
                check_fs=`echo $fsname | grep '^/'`
		fs_check=`lvdisplay $fsname 2>/dev/null`
		fs_mount_check=`mount 2>/dev/null| grep $fsname 2>/dev/null`
                if [[ "$check_fs" == "" ]]
                then
                        printf " FS name should start with /\n"
                        continue
			# Checking for FS is exits or not..
		elif [[ "$fs_check" == "" && $fs_mount_check == ""  &&  ! -d $fsname   ]]
		then
			printf "$fsname FS does not exits ..\n"				
		else
			 break
                 fi
	fi
        done
	fcheck=`echo $fsname|awk 'gsub("/"," "); {print  $3}'`
        fsname_check=`mount 2>/dev/null|grep "$fcheck"`
        if [[ "$fsname_check" == "" ]]
        then
                printf "$fsname is not mounted yet.. Plz mount it and try unmounting.. \n"
        else
                printf "Are you sure want to unmount $fsname [y/n]?: "
                read confrm
                if [[ "$confrm" == "y" ]]
                then
                        umount $fsname  2> /dev/null
			if [ $? -eq 0 ]
			then
				printf " $fsname unmounted successfully..\n"
			else
				printf "Issue while unmounting $fsname FS..\n"
			fi	
                elif [[ "$confrm" == "n" || "$confrm" == "" ]]
                then
                        printf "Unmounting FS is not confirmed...\n"
                fi

        fi
}


#######################################################################################
## more_lvm function is for, based on the users menu option, call the lvm functions
#######################################################################################
more_lvm ()
{
	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "Logical Volume Management"
	echo -e "\033[0m"
        LVM_MENU[0]="0) List Volume Group "
        LVM_MENU[1]="1) List physical Volumes"
        # LVM_MENU[2]="3) List free Physical volumes"
        LVM_MENU[3]="2) Get UUID information"
        LVM_MENU[4]="3) Create Volume Group"
        LVM_MENU[5]="4) Extend Volume Group"
        LVM_MENU[6]="5) Create Logical Volume"
        LVM_MENU[7]="6) Mount Logical Volume"
        LVM_MENU[8]="7) Unmount Logical Volume"
        LVM_MENU[9]="8) Extend Logical Volume"
        LVM_MENU[10]="9) List Logical Volume"
        LVM_MENU[11]="r) Command prompt"
 	ITEMCNT_PERF="${#LVM_MENU[@]}"
        for MENULINE in "${LVM_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
	printf "\n Enter your choice: "
    #read selection
    #echo ""
    get_opt
    ret=$?
    case $ret in
        "0")
		clear   		
		print_header
		echo -e "\033[1m"
        	tput cup  15 15 ; echo  "List of Volume Groups"
		# printf "\t\t\t List of Volume Groups "
		echo -e "\033[0m"
		# printline
        	get_vg_list
		# printline
	        moveon
		audit_log "0  from  more_lvm " List_volume_Group
		more_lvm
	        ;;
        "1")
        	
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t List of Physical Volumes "
        	tput cup  15 15 ; echo  "List of Physical Volumes"
		echo -e "\033[0m"
		# printline
	        get_pv_info
		audit_log "1  from  more_lvm " Get_PV_info
		# printline
        	moveon
		more_lvm
	        ;;
       #  "3")
       #  	
       #  	clear   		
       #  	print_header
       #  	echo -e "\033[1m"
       #  	# printf "\t\t\t List of Free Physical Volumes "
       #  	tput cup  15 15 ; echo  "List of Free Physical Volumes"
       #  	echo -e "\033[0m"
       #  	# printline
       #  	list_free_pv
       #  	audit_log "3  from  more_lvm " List_Free_PV
       #  	# printline
       #          moveon
       #  	more_lvm
       #  	;;
        "2")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t UUID Information"
        	tput cup  15 15 ; echo  "UUID Information"
		echo -e "\033[0m"
		# printline
        	get_uuid_info
		audit_log "2  from  more_lvm " Get_UUID_info
		# printline
	        moveon
		more_lvm
        	;;
        "3")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Volume Group Creation"
        	tput cup  15 15 ; echo  "Volume Group Creation"
		echo -e "\033[0m"
		# printline
		create_vg
		audit_log "3  from  more_lvm " Create_VG
		# printline
	        moveon
		more_lvm
        	;;
	
        "4")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Extend Volume Group "
        	tput cup  15 15 ; echo  "Extend Volume Group"
		echo -e "\033[0m"
		# printline
		extend_vg
		audit_log "4  from  more_lvm " Extend_VG
		# printline
	        moveon
		more_lvm
        	;;
	
        "5")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Create Logical Volume"
        	tput cup  15 15 ; echo  "Create Logical Volume"
		echo -e "\033[0m"
		# printline
		create_lv
		audit_log "5  from  more_lvm " Create_LV
		# printline
	        moveon
		more_lvm
        	;;
        "6")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Mount Logical Volume"
        	tput cup  15 15 ; echo  "Mount Logical Volume"
		echo -e "\033[0m"
		# printline
		fs_mount
		audit_log "6  from  more_lvm " FS_mount
		# printline
	        moveon
		more_lvm
        	;;
        "7")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Unmount Logical Volume"
        	tput cup  15 15 ; echo  "Unmount Logical Volume"
		echo -e "\033[0m"
		# printline
		fs_unmount
		audit_log "7  from  more_lvm " FS_unmount
		# printline
	        moveon	
		more_lvm
        	;;
        "8")
	        
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t Extend Logical Volume"
        	tput cup  15 15 ; echo  "Extend Logical Volume"
		echo -e "\033[0m"
		# printline
		extend_lv
		audit_log "8  from  more_lvm " Extend_Lv
		# printline
	        moveon
		more_lvm
        	;;
        "9")
		clear   		
		print_header
		echo -e "\033[1m"
		# printf "\t\t\t List of Logical Volume"
        	tput cup  15 15 ; echo  "List of Logical Volume"
		echo -e "\033[0m"
		# printline
        	list_lvs
		audit_log "9  from  more_lvm " List_LV
		# printline
	        moveon	
		more_lvm
        	;;
                $CANCEL)
	                stty sane
        	        return
                	;;
		$HELP)
			MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A11 "LVM_MGMT:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;

		$DASHBOARD)
			dash_board
			;;
		 $CPROMPT)   run_cmd;;	
                $EXIT)
	                exit_admin
        	        ;;
                $REFRESH)
                	more_lvm
	                return
        	        ;; 
             m|M|*)
		# print_header
		menu
		#return
	        ;;
   esac
}

##########################################################################
# rhl3_get_lv_list function for listing the Logical volumes
##########################################################################
rhl3_get_lv_list ()
{
	# printline
	printf "\e[1m"
	printf "%-30s %-18s %-18s %-18s %-18s \n" "LVName"  "Belongs to VG" "Size" "Mounted" "Mounted On"
	printf "\e[0m"
	# printline
	lvscan 2>/dev/null | grep -w "ACTIVE" | awk '{ gsub(/"/,"");print $4 }' > /$TMP_DIR/lv_op
	while read i
	do
	lvname=`lvdisplay $i 2>/dev/null  | grep -i "LV Name" | awk '{ print $3 }'`
	vgname=`lvdisplay $i 2>/dev/null  | grep -i "VG Name" | awk '{ print $3}'`
	lvsize=`lvdisplay $i 2>/dev/null  | grep -i "LV Size" | awk '{ print $3 " " $4 }'`
	mnt=`mount 2>/dev/null | grep -wi "$lvname"`
	if [[ "$mnt" != "" ]]
	then
	        mounted="Yes"
	        mntpt=`mount 2>/dev/null | grep -wi "$lvname"| awk '{print $3}'`
	else
	        mounted="No"
	        mntpt="-"
	fi
	
	printf "%-30s %-18s %-18s %-18s %-18s  \n" "$lvname" "$vgname" "$lvsize" "$mounted" "$mntpt"
	done < "/$TMP_DIR/lv_op"
	# printline
	rm -f /$TMP_DIR/lv_op 2>/dev/null
}


##########################################################################
# rhl3_get_pvs function for listing the physical volumes
##########################################################################
rhl3_get_pvs ()
{
	# printline
	printf "\e[1m"
	printf "%-15s %-10s %-10s %-15s %-40s \n" "PVName" "VGName" "PSize" "FreeSize" "Status"
	printf "\e[0m"
	# printline
	#pvscanop=`pvscan | grep -v "reading" | grep -v "total"`
	pvscan 2>/dev/null | grep -v "reading" | grep -v "total" >> /$TMP_DIR/pvscan
	sed -e '/^$/d'  /$TMP_DIR/pvscan > /$TMP_DIR/pvscanop
	while read lines
	do
		pvname=`echo $lines | awk '{gsub(/"/,""); print $5 }'`
		vgname=`echo $lines | awk '{gsub(/"/,""); print $8 }'| awk '{gsub(/no/,"-"); print $1}'`
		pstatus=`echo $lines | awk '{gsub(/"/,""); print $3 }'`
		if [[ "$pstatus" == "ACTIVE" ]]
		then
		        psize=`echo $lines| grep -wi "free" |awk '{ gsub(/free/,"");gsub(/[\[\]]/,""); print $9 " " $10 }'`
		        freesize=`echo $lines | grep -wi "free"| awk '{gsub(/free/,"");gsub(/[\[\]]/,"");print $12 " " $13}'`
		elif [[ `echo $lines| grep -wi "free"` && "$pstatus" != "ACTIVE"  ]]
		then
		        psize=`echo $lines| grep -wi "free" |awk '{gsub(/[\[\]]/,""); print $9 " " $10 }'`
		        freesize=`echo $lines | grep -wi "free"| awk '{gsub(/free/,"");gsub(/[\[\]]/,"");print $12 " "  $13}'`
		elif [[ "$pstatus" == "inactive" ]]
		then
		        psize=`echo $lines | grep -wi "no"| awk ' {gsub(/[\[\]]/,""); print $10 " "  $11}'`
		        freesize="-"
		fi
		printf "%-15s %-10s %-10s %-15s %-40s \n" "$pvname" "$vgname" "$psize" "$freesize" "$pstatus"
	done < "/$TMP_DIR/pvscanop"
	rm -f  /$TMP_DIR/pvscanop  /$TMP_DIR/pvscan 2>/dev/null

}

##########################################################################
# rhl3_get_vg_list function for listing the  volume groups
##########################################################################
rhl3_get_vg_list ()
{
	## printline
	printf "\e[1m"
	printf "%-30s %-10s  %-10s %-18s %-15s %-12s %-40s \n" "VGName" "#PV" "#LV" "TotalSize" "Available" "Status" "UUID"
	printf "\e[0m"
	#printline
	vgscan 2>/dev/null | grep -wi "active" | awk '{ gsub(/"/,"");print $7 }' > /$TMP_DIR/vg_op
	vgscan 2>/dev/null | grep -wi "inactive" | awk '{ gsub(/"/,"");print $7 }' > /$TMP_DIR/vg_iop
	#cat /$TMP_DIR/vg_op | wc -l
	# cat /$TMP_DIR/vg_iop
	# for i in $nop
	
	while read i
	do
		#       printf $i
		# vgdisplay $i
		vgname=`vgdisplay $i 2>/dev/null | grep -i "VG Name" | awk '{ print $3 }'`
		vgsize=`vgdisplay $i 2>/dev/null | grep -i "VG Size" | awk '{ print $3 " " $4 }'`
		npv=`vgdisplay $i 2>/dev/null | grep -i "Cur PV" | awk '{ print $3 }'`
		nlv=`vgdisplay $i 2>/dev/null | grep -i "Cur LV" | awk '{ print $3 }'`
		freesize=`vgdisplay $i 2>/dev/null | grep -iw "Free"| awk '{ print $7 " " $8 }'`
		uuid=`vgdisplay $i  2>/dev/null | grep -i "VG UUID" | awk '{ print $3 }'`
		printf "%-30s %-10s %-10s %-18s %-15s %-12s %-40s \n" "$vgname" "$npv" "$nlv" "$vgsize" "$freesize" "Active"  "$uuid"
		done < "/$TMP_DIR/vg_op"
		
		while read j
		do
		#vgdisplay -D $j
		vgname=`vgdisplay -D $j 2>/dev/null  | grep -i "VG Name" | awk '{ print $3 }'`
		npv=`vgdisplay -D $j 2>/dev/null | grep -i "Cur PV" | awk '{ print $3 }'`
		nlv=`vgdisplay -D $j 2>/dev/null | grep -i "Cur LV" | awk '{ print $3 }'`
		vgsize=`vgdisplay -D $j 2>/dev/null | grep -i "VG Size" | awk '{ print $3 " " $4 }'`
		freesize=`vgdisplay -D $j 2>/dev/null | grep -iw "Free"| awk '{ print $7 " " $8 }'`
		uuid=`vgdisplay -D $j 2>/dev/null | grep -i "VG UUID" | awk '{ print $3 }'`
		printf "%-30s %-10s %-10s %-18s %-15s %-12s %-40s \n" "$vgname" "$npv" "$nlv" "$vgsize" "$freesize" "Inactive"  "$uuid"
		
	done < "/$TMP_DIR/vg_iop"
	
	rm -f /$TMP_DIR/vg_op /$TMP_DIR/vg_iop 2>/dev/null

}

##########################################################################
# rhl3_create_vg function for creating the volume groups 
##########################################################################
rhl3_create_vg ()
{
#	printf "\t\t\t Creating Volume Group \n"
	rhl3_get_vg_list
        printf "______________________________________________________________________________________________________________________________________ \n \n"
	while ( true )
	do
		printf "Enter PV Name : "
		read pvname
		if [[ "$pvname" == "" ]]
		then
			printf "PV Name should not be empty\n"
		else
			if [[ "$pvname" == "q" ]]
			then
				printf "Exiting from Create VG's\n"
				return
			else
				pname=`rhl3_get_pvs | grep -v "PVName" |  awk '{print $1}' |grep "$pvname"`
				if [[ "$pname" == "" ]]    #### check if PV exist
		        	then
	        	        	printf " $pvname  PV does not exists , Please create a new PV\n"
					continue
				else
					break
				fi
			fi
		fi
	done
	
	while ( true )
	do
		printf "Enter VG Name: "
		read NewVgName
		vg_check=`rhl3_get_vg_list | grep -i $NewVgName` 
		if [[ "$vg_check" != "" ]]   #### Check if VG Name is already in use #####
		then
	        	printf "$NewVgName VG already exists,Pick a new VGName\n"
			continue
		else
			if [[ "$NewVgName" == "q" ]]
			then
				printf "Exiting from Create VG's\n"
				return
			else
				break
			fi
		fi	
	done
	VGName=`rhl3_get_pvs | grep -i $pvname | awk '{print $2}'`    ####Check if PV is Allocatable/Free to be assigned to a VG ########
	allocatable=`pvdisplay $pvname 2>/dev/null| grep -i "Allocatable"|awk '{print $2}'`		
	if [[ "$allocatable" == "yes" ]]
	then
		printf "$pvname is already part of $VGName\n"
	else
		echo $pvname is Free
		vgcreate $NewVgName $pvname  2> /dev/null
		if [ $? -eq 0 ]
		then
			printf "$NewVgName VG create successfully\n"
		else
			printf "$NewVgName VG has not created..\n"
		fi
	fi
}

##########################################################################
# rhl3_extend_vg function for extending the volume groups 
##########################################################################
rhl3_extend_vg ()
{
#	printf "\t\t\t Extending Volume Group \n"
	rhl3_get_vg_list
        printf "______________________________________________________________________________________________________________________________________ \n \n"
	while ( true )
	do
		printf "Enter PV Name : "
		read pvname
		if [[ "$pvname" == "q" ]]
		then
			printf "Exiting from Extend VG \n"
			return
		else
			pname=`rhl3_get_pvs | grep -v "PVName" |  awk '{print $1}' |grep "$pvname"`
		        if [[ "$pname" == "" ]]    #### check if PV exist
	        	then
	                	printf " $pvname  PV does not exists , Please create a new PV\n"
		                continue
	        	else
	                	break
		        fi
		fi
	done
	while ( true )
	do
		printf "Enter VG Name: "
		read VgName
		vg_check=`rhl3_get_vg_list | grep -i $NewVgName` 
		if [[ "$VgName" == "" ]]   #### Check if VG Name is already in use #####
		then
	        	printf "Plz Enter a Valid VGName\n"
			continue
		elif [[ "$VgName" == "q" ]]
		then
			printf " Exiting from Extending VG's\n"
			return
		elif [[ "$vg_check" == "" ]]
		then
			printf "VG Does not exits\n"
			continue
		else
			break
		fi
	
		####Check if PV is Allocatable/Free to be assigned to a VG ########
	
		allocatable=`pvdisplay $pvname 2>/dev/null| grep -i "Allocatable"|awk '{print $2}'`		
		if [[ "$allocatable" == "yes" ]]
		then
			printf "$pvname is already part of a Volume Group \n"
			continue
		else
			echo $pvname is Free
			break
		fi
	done
	vgextend  $VgName $pvname  2> /dev/null
	if [ $? -eq 0 ]
	then
		printf "$VgName VG extended  successfully\n"
	else
		printf "$VgName VG is not extended..\n"
	fi
}

##########################################################################
# rhl3_remove_vg function for removing the volume groups 
##########################################################################
rhl3_remove_vg ()
{
#	printf "\t\t\t Volume Group Remove\n"
	rhl3_get_vg_list
        printf "______________________________________________________________________________________________________________________________________ \n \n"
	while ( true )
	do
		printf "Enter VG Name: "
		read NewVgName
		vg_check=`rhl3_get_vg_list | grep -i $NewVgName` 
		if [[ "$vg_check" == "" ]]   #### Check if VG Name is already in use #####
		then
	        	printf "$NewVgName VG does not exists..\n"
			continue
		else
			if [[ "$NewVgName" == "q" ]]
			then
				printf " Exiting from Remove VG's\n"
				return
			else
				break
			fi
		fi
	done
	# npv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $2}'`
	# nlv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $3}'`
	# nlv=`rhl3_get_pvs | grep -v "PVName" |  awk '{print $3}' |grep "$NewVgName"`
	nlv=`rhl3_get_vg_list | grep -v "PVName" |  grep "$NewVgName" | awk '{print $3}' `
	if [[ $nlv -gt 0 ]]
	then
		printf "VG contains $nlv LV's . can not remove $NewVgName VG \n"
		# printf "$nlv LV's are there. can not remove $NewVgName VG \n"
	else
		
	printf "Inorder to do VGremove, deactivate VG. Are you sure want to continue [y/n]?:  "	
	read confrm
	if [[ "$confrm" == "y" ]]
	then
		vgchange -an $NewVgName 
		if [[ $? -eq 0 ]]
		then
			printf "Deactivated $NewVgName successfully..\n"
			vgremove $NewVgName 2>/dev/null
			if [[ $? -eq 0 ]]
			then
				printf "$NewVgName VG Removed successfully\n"
			else
				printf "$NewVgName VG is not  Removed \n"
			fi
		else
			printf " Issue with deactivating the $NewVgName ..\n"
		fi
	elif [[ "$confrm" == "n" || "$confrm" == "" ]]
	then
		printf "Exiting from VG deactivation..\n"
	fi
	fi
}

##########################################################################
# rhl3_reduce_vg function for reducing the volume groups 
##########################################################################
rhl3_reduce_vg ()
{
# 	echo -e "\033[1m"
# 	printf "\t\t\t Reduce the Volume Group\n"
# 	echo -e "\033[0m"
	rhl3_get_vg_list
        printf "______________________________________________________________________________________________________________________________________ \n \n"
	while ( true )
	do
		printf "Enter PV Name : "
		read pvname
		if [[ "$pvname" == "" ]]
		then
			printf "PV Name should not be empty\n"
		else
			if [[ "$pvname" == "q" ]]
			then
				printf " Exiting from Reduce VG's\n"
				return
			else
				pname=`rhl3_get_pvs | grep -v "PVName" |  awk '{print $1}' |grep "$pvname"`
				if [[ "$pname" == "" ]]    #### check if PV exist
		        	then
	        	        	printf " $pvname  PV does not exists \n"
					continue
				else
					break
				fi
			fi
		fi
	done
	
	while ( true )
	do
		printf "Enter VG Name: "
		read VgName
		printf " rhl3_get_vg_list | grep -i $VgName \n"
		vg_check=`rhl3_get_vg_list | grep -i $VgName` 
		if [[ "$vg_check" == "" ]]   #### Check if VG Name is already in use #####
		then
	        	printf "$VgName VG does not exists\n"
			continue
		else
			if [[ "$VgName" == "q" ]]
			then
				printf "Exiting from Reduce VG's\n"
				return
			else
				break
			fi
		fi
	
	done	
	# npv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $2}'`
	#  nlv=`vgs 2>/dev/null| grep -v "PV" | awk '{print $3}'`
	npv=`rhl3_get_vg_list | grep -v "PVName" |  grep "$VgName" | awk '{print $2}' `
	# printf "no of PVS .. $npv \n"
	nlv=`rhl3_get_vg_list | grep -v "PVName" |  grep "$VgName" | awk '{print $3}' `
	printf "Are you sure want to reduce Volume Group [y/n]?:  "	
	read confrm
	if [[ "$confrm" == "y" ]]
	then
		if [ $npv -eq 1 ]
		then
			printf "Only one LV is available. Can not reduce the VG..\n"
		else
			vgreduce $VgName $pvname  2> /dev/null
			if [ $? -eq 0 ]
			then
				printf " $VgName VG reduced successfully..\n"
			else
				printf " $VgName VG not reduced ..\n"
			fi
		fi		
	elif [[ "$confrm" == "n" || "$confrm" == "" ]]
	then
		printf "Reduce VG is not confirmed.. Exiting from REduce VG \n"
	fi		
}

##########################################################################
# rhl3_fs_mount  function for mounting the Filesystem
##########################################################################
rhl3_fs_mount ()
{
	rhl3_get_lv_list	
	while ( true )
	do
		printf "Enter the FS Name : "
		read fsname
		if [[ "$fsname" == "q" ]]
		then
			printf "Exiting from Mounting FS..\n"
			return
		else
			check_fs=`echo $fsname | grep '^/'`
			fs_check=`lvdisplay $fsname 2>/dev/null`
		        if [[ "$check_fs" == "" ]]
        		then
        			printf " FS name should start with /\n"
	        	        continue
			elif [[ "$fs_check" == "" ]]
			then
				printf "$fsname FS does not exits \n" 
				continue
			else
        		       break
		         fi
		fi
	done
	mount_fsname=`echo $fsname | awk '{gsub(/.*\//,""); print $1}'`
	fsname_check=`mount 2>/dev/null|grep "$mount_fsname"`
	if [[ "$fsname_check" != "" ]]
        then
                printf "$fsname is already in mounted \n"
        else
		while ( true )
		do
			printf "Enter the mount point : "
			read mount_point
			if [[ "$mount_point" == "" ]]
			then
				printf "quiting from mount FS..\n"
				return
			else
				mountpoint_check=`echo $mount_point | grep '^/'`
				if [[ "$mountpoint_check" == "" ]]
				then
					printf " Mount point should start with /\n"
					continue
				else
					break
				fi
			fi	
		done
		if [ ! -d "$mount_point" ]
		then
			printf " $mount_point doest not exists. want to create it [y/n]?: "
			read confrm
			if [[ "$confrm" == "y" ]]
			then
				mkdir -p $mount_point 2>/dev/null
			elif [[ "$confrm" == "n" || "$confrm" == "" ]]
			then
				printf " Creating $mount_point mount point is not confirmed.. \n"
				printf "Exiting from Mount FS..\n"
				return
			fi
		fi
	
		printf "Are you sure want to mount $fsname [y/n]?: "
                read mconfrm
      		if [[ "$mconfrm" == "y" ]]
                then
    		        mount $fsname $mount_point  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$fsname mounted successfully\n"
				else
					printf " $fsname is not mounted..\n"
				fi
		         elif [[ "$mconfrm" == "n" || "$mconfrm" == "" ]]
		         then
                       		printf " Mounting FS is not confirmed...\n"
		          fi
		fi		
}

##########################################################################
# rhl3_fs_unmount function for unmounting the filesystem 
##########################################################################
rhl3_fs_unmount ()
{
	rhl3_get_lv_list	
	while ( true )
        do
                printf "Enter the FS Name : "
                read fsname
		if [[ "$fsname" == "q" ]]
		then
			printf "Exiting from Unmounting the FS \n"
			return
		else
               		check_fs=`echo $fsname | grep '^/'`
			fs_check=`lvdisplay $fsname 2>/dev/null`
        	        if [[ "$check_fs" == "" ]]
                	then
                        	printf " FS name should start with /\n"
	                        continue
				# Checking for FS is exits or not..
			elif [[ "$fs_check" == "" ]]
			then
				printf "$fsname FS does not exits ..\n"				
			else
				 break
	                 fi
		fi
        done
	fcheck=`echo $fsname|awk 'gsub("/"," "); {print  $3}'`
        fsname_check=`mount 2>/dev/null|grep "$fcheck"`
        if [[ "$fsname_check" == "" ]]
        then
                printf "$fsname is not mounted yet.. Plz mount it and try unmounting.. \n"
        else
                printf "Are you sure want to unmount $fsname [y/n]?: "
                read confrm
                if [[ "$confrm" == "y" ]]
                then
                        umount $fsname  2> /dev/null
			if [ $? -eq 0 ]
			then
				printf " $fsname unmounted successfully..\n"
			else
				printf "Issue while unmounting $fsname FS..\n"
			fi	
                elif [[ "$confrm" == "n" || "$confrm" == "" ]]
                then
                        printf "Unmounting FS is not confirmed...\n"
                fi

        fi
}

##########################################################################
# rhl3_create_lv function for creating the Logical volume  
##########################################################################
rhl3_create_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Creating Logical Volume \n"
#	echo -e "\033[0m"
	rhl3_get_lv_list
	while ( true )
	do	
		printf "Enter VG Name : "
		read vgname
		if [[ "$vgname" == "" ]]
		then
			printf "VG Name should not be empty\n"
			continue
		else		
			if [[ "$vgname" == "q" ]]
			then
				printf "Exiting from Create LV\n"
				return
			else
				vg_check=`rhl3_get_vg_list |grep -w "$vgname" | awk '{ print $1}'`
				if [[ "$vgname" != "" ]]
				then
					if [[ "$vg_check" == "" ]]
					then
						printf "$vgname VG does not exists\n"
						continue
					else
						break
					fi		
				fi			
			fi
		fi
	done
	while ( true )
	do
		printf "Enter LV Name : "
		read lvname
		lv_check=`rhl3_get_lv_list | grep -v LV |grep -i "$lvname"`
		if [[ "$lvname" == "" ]]
		then
			printf "LV Name should not be empty\n"
			continue
		else
			if [[ "$lvname" == "q" ]]
			then
				printf "Exiting from create LV \n"
				return
			else
				if [[ "$lv_check" != "" ]]
				then
					printf "$lvname name already exists \n"
					continue
				else
					break
				fi
			fi
		fi
	done
	while ( true )
        do
                printf "Enter the Size of LV in units [eg 10 M/10 G] :  "
                read lvsize                          ################ New Size of LV##############
                if [[ "$lvsize" == "" ]]
                then
                        printf "Size should not be Empty\n"
                        continue
                else
			if [[ "$lvsize" == "q" ]]
			then
				printf "Exiting from Creating LV\n"
				return
			else
				r_unit=`echo $lvsize|grep -i -w "[mG]"`
	                        r_size=`echo $lvsize | awk '{ sub (/[mMgG]/,"");print $1}'`
        	                if [[ "$r_size" == "0" ]]
                	        then
                        	        printf " Please enter the Non zero size \n"
                                	continue
	                        else
        	                        dec=`echo $lvsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
                	                if [[ "$dec" != "" ]]
                        	        then
                                	        printf "  Size should not be decimal. Plz enter the rounded size\n"
                                        	continue
	                                else
        	                                if [[ "$r_unit" == "" ]]
                	                        then
                        	                        printf "Please enter the size in units [M/G] \n"
                                	                continue
                                        	else
                                                	nlvsize=`echo $lvsize | awk '{ sub (/ /,""); print $1 }'`
        	                                        break
                	                        fi
                        	        fi
	                        fi
        	        fi
		fi
        done
	while ( true )
	do
		printf "Enter the mount point : "
		read lvmount
		lvmount_check=`cat /etc/fstab 2>/dev/null|awk '{print $2}' | grep -w $lvmount`
		if [[ "$lvmount_check" != "" ]]
		then
			printf "Mount point is already exits \n"
			continue
		else
			if [[ "$lvmount" == "q" ]]
			then
				printf "Exiting from Creating LV\n"
				return
			else
				check_lv=`echo $lvmount | grep '^/'`
				if [[ "$check_lv" == "" ]]
				then
					printf " Mount point should start with /\n"
					continue
				else
					break
				fi
			fi							
		fi
	done
	free_size=`vgdisplay $vgname 2>/dev/null| grep -i "FREE  PE" | awk '{print $7 $8}'`	
	printf "Free space available on $vgname is $free_size\n"
	printf "Are you sure want to create LV [y/n] ?:  "
	read confrm
	if [[ "$confrm" == "y" ]]
	then
		lvcreate -L $nlvsize -n $lvname $vgname  2> /dev/null
		if [ $? -eq 0 ]
		then
			printf " Logical volume created successfully\n";
			newlvname="/dev/$vgname/$lvname"
			printf "New LV name is $newlvname\n"
			echo "Creating file system..\n"
			mke2fs -j $newlvname  2> /dev/null
			if [ $? -eq 0 ]
			then
				# Creating the mount point directory
				mkdir $lvmount
				echo "Mounting the $lvmount ..\n"
				mount $newlvname $lvmount  2> /dev/null
				if [ $? -eq 0 ]
				then
					echo " Completed....."
				else
			 		printf "Issue with the mounting FS\n"
				fi
			else
				printf " Issue with creating FS\n"
			fi	
		else
			printf "LV creation is not success \n"		
		fi
	elif [[ "$confrm" == "n" || "$confrm" == "" ]]
	then
		printf "LV creation not confirmed.. Exiting from Creating LV \n"
	fi					
}


##########################################################################
# rhl3_extend_lv function for extending the Logical volume  
##########################################################################
rhl3_extend_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Extending Logical Volume \n"
#	echo -e "\033[0m"
	rhl3_get_lv_list
        while ( true )
        do
                printf "Enter  full LV Name  starts with /: "
                read lvname
		if [[ "$lvname" == "" ]]
		then
			printf "LV Name should not be Empty\n"
			continue
		fi
		if [[ "$lvname" == "q" ]]
		then
			printf "Exiting from Extend LV\n"
			return
		else
			lv_check=`rhl3_get_lv_list | grep "$lvname" | awk '{print $1}'`
			check_fs=`echo $lvname | grep '^/'`
			if [[ "$check_fs" == "" ]]
	                then
        	                printf " LV name should start with /\n"
                	        continue
			fi
        	        if [[ "$lv_check" == "" ]]
                	then
                		printf "$lvname name does not exists \n"
        	                continue
                	else
                        	break
	                fi
		fi
	done
	while ( true )
        do
                printf "Enter the New Desired Size of LV in units [eg 10 M/10 G] :  "
                read lvsize                          ################ New Size of LV##############
                if [[ "$lvsize" == "" ]]
                then
                        printf "Size should not be Empty\n"
                        continue
                else
			if [[ "$lvsize" == "q" ]]
			then
				printf "Exiting from Extend LV\n"
				return
			else
        	                r_unit=`echo $lvsize|grep -i -w "[mG]"`
                        r_size=`echo $lvsize | awk '{ sub (/[mMgG]/,"");print $1}'`
                        if [[ "$r_size" == "0" ]]
                        then
                                printf " Please enter the Non zero size \n"
                                continue
                        else
                                dec=`echo $lvsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
                                if [[ "$dec" != "" ]]
                                then
                                        printf "  Size should not be decimal. Plz enter the rounded size\n"
                                        continue
                                else
                                        if [[ "$r_unit" == "" ]]
                                        then
                                                printf "Please enter the size in units [M/G] \n"
                                                continue
                                        else
                                                nlvsize=`echo $lvsize | awk '{ sub (/ /,""); print $1 }'`
                                                break
                                        fi
                                fi
                        fi
                fi
	fi
        done
        printf "Are you sure want to Extend LV [y/n] ?:  "
        read confrm
        if [[ "$confrm" == "y" ]]
        then
		#echo "lvextend -L +$nlvsize $lvname"
	        lvextend -L $nlvsize  $lvname  2> /dev/null
        	if [ $? -eq 0 ]
	        then
        	        printf " Logical volume extended successfully\n";
			# Resizing the FS..
			resize2fs $lvname   2> /dev/null	
			if [ $? -eq 0 ]
			then
				printf " $lvname FS resized successfully\n"
			else
				printf "Issue with $lvname FS resizing...\n"
			fi
       		 else
                	printf "LV Extend is not success \n"
	        fi
        elif [[ "$confrm" == "n" || "$confrm" == "" ]]
        then
                printf "LV Extension not confirmed.. Exiting from Extending LV \n"
	fi
}


##########################################################################
# rhl3_remove_lv function for removing the Logical volume  
##########################################################################
rhl3_remove_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Removing the LV \n"
#	echo -e "\033[0m"
	rhl3_get_lv_list
	while ( true )
	do
		printf "Enter  full LV Name  starts with /: "
                read lvname
                if [[ "$lvname" == "" ]]
                then
                        printf "LV Name should not be Empty\n"
                        continue
		else	
			if [[ "$lvname" == "q" ]]
			then
				printf "Exiting from Extend LV\n"
				return
			else
	        	        lv_check=`rhl3_get_lv_list | grep -w "$lvname" | awk '{print $1}'`
	                	check_fs=`echo $lvname | grep '^/'`
		                if [[ "$check_fs" == "" ]]
        		        then
                		        printf " LV Name should start with /\n"
                        		continue
		                fi
        		        if [[ "$lv_check" == "" ]]
                		then
                        		printf "$lvname name does not exists \n"
	        	                continue
        	        	else
                	        	break
		        	fi
			fi
		fi
	done
	lvm=`echo $lvname`
	mount_fsname=`echo $lvname | awk '{gsub(/.*\//,""); print $1}'`
	mount_point=`mount 2>/dev/null| grep  "$mount_fsname" | awk '{print $3 }'`
	if [[ "$lvm" == "" ]]
	then
		printf " Given $lvname does not exists \n"	
	else
		printf " Are you sure want to remove $lvm  LV [y/n]? : "	
		read confrm
		if [[ "$confrm" == "y" ]]
		then
			# Here no need to check if only the mounted FS should be mount. reason is, before removing the 
			# FS checking FS is exists or not uisng the mount command. only mounted FS only will come there
			fcheck=`echo $lvname|awk 'gsub("/"," "); {print  $3}'`
		        fsname_check=`mount 2>/dev/null|grep "$fcheck"`
		        if [[ "$fsname_check" == "" ]]
		        then
                		printf "$lvname is not mounted , deleting $lvname  \n"
			else
				printf "Unmounting the $lvm LV ...\n"
				umount $lvm  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf " $lvm unmounted successfully\n"
					unmounted_flag=1	
				else
					printf "Issue with unmounting $lvm LV\n"
				fi
			fi
					# removing the LV
				lvremove $lvm	  2> /dev/null
				if [ $? -eq 0 ]
				then
					printf "$lvm LV removed successfully\n"
				else
					 printf " $lvm LV is not removed\n"
					if [[ "$unmounted_flag" == "1" ]]
					then
					     	mount $lvm $mount_point  2> /dev/null
					fi
				fi
		elif [[ "$confrm" == "n" || "$confrm" == ""  ]]
		then
			printf " LV deletion has not confirmed...Exiting from Remove LV\n"
		fi
	fi
}

##########################################################################
# rhl3_reduce_lv function for reducing the Logical volume  
##########################################################################
rhl3_reduce_lv ()
{
#	echo -e "\033[1m"
#	printf "\t\t\t Reducing the  LV \n"
#	echo -e "\033[0m"
	rhl3_get_lv_list	
	while ( true )
	do
		printf "Enter Full  LV Name  starts with /: "
                read lvname
                if [[ "$lvname" == "" ]]
                then
                        printf "LV Name should not be Empty\n"
                        continue
                fi
		if [[ "$lvname" == "q" ]]
		then
			printf "Exiting from Reduce LV \n"
			return
		else
               		lv_check=`rhl3_get_lv_list | grep -w  "$lvname" | awk '{print $1}'`
	                check_fs=`echo $lvname | grep '^/'`
        	        if [[ "$check_fs" == "" ]]
                	then
                        	printf " FS name should start with /\n"
	                        continue
        	        fi
                	if [[ "$lv_check" == "" ]]
	                then
        	                printf "$lvname name does not exists \n"
                	        continue
	                else
        	                break
                	fi
		fi
	done
	lvm=`echo $lvname`
	mount_fsname=`echo $lvname | awk '{gsub(/.*\//,""); print $1}'`
	mount_point=`mount 2>/dev/null| grep  "$mount_fsname" | awk '{print $3 }'`
	current_lvsize=`rhl3_get_lv_list | grep -i "LV Size" | awk '{print $3 " " $4}'`
	current_unit=`echo $current_lvsize | awk '{print $2}'`
	current_size=`echo $current_lvsize | awk '{print  $1}'`
	# current_size=`printf "%.0f\n" "$current_fsize"`
	# echo "Current Size is :- .. " $current_size
	# current_size=`echo $current_lvsize | awk '{printf "%.0f\n"  $1}'`
	while ( true )
	do
		printf "Enter the New Desired Size of LV in units [eg 10 M/10 G] :  "
		read rsize                          ################ New Size of LV##############
		if [[ "$rsize" == "" ]]
		then
			printf "Size should not be Empty\n"
			continue
		else
			if [[ "$rsize" == "q" ]]
			then
				printf "Exiting from Reducing LV\n"
				return
			else
				r_unit=`echo $rsize|grep -i -w "[mG]"`
        		       	r_size=`echo $rsize | awk '{ sub (/[mMgG]/,"");print $1}'`
                		if [[ "$r_size" == "0" ]]
		                then
        		                printf " Please enter the Non zero size \n"
                		        continue
	                	else
					dec=`echo $rsize | awk '/\./{print " Size should not be decimal. Plz enter the rounded size" }'`
					if [[ "$dec" != "" ]]
					then
						printf "  Size should not be decimal. Plz enter the rounded size\n"
						continue
					else
	        	                	if [[ "$r_unit" == "" ]]
	        	        	        then	
        	        	        	        printf "Please enter the size in units [M/G] \n"
                	                		continue
		        	                else
							# printf "Current unit is  \t : $current_unit .. given unit \t : $r_unit\n"
        		                	        nrsize=`echo $rsize | awk '{ sub (/ /,""); print $1 }'`
							# both current & given units are same then
							r_unit=`echo $r_unit | awk '{ print $2 }'`
							# printf "Current unit .. $current_unit  R_unit is .. $r_unit\n"
							if [[ `echo $current_unit | grep -i "$r_unit"` != "" ]]
							then
								# reduce_size=$(( current_size - r_size ))
								# reduce_size=echo echo $current_size - echo $r_size|bc
								reduce_size=`echo "$current_size-$r_size"|bc`
								reduce_unit="$r_unit"
								# printf "Roselin\n"
								# echo $reduce_size $reduce_unit
								# printf "Roselin\n"
							elif [[ `echo $current_unit | grep -i "G"` != "" && "$r_unit" == "M" ]] # given size is M & current size is GB 
							then
								# size=$((current_size * 1024 ))
								#  reduce_size=$((size - r_size ))				
								# size=echo  echo $current_size *1024|bc
								# reduce_size=echo echo $size - echo $r_size|bc
								size=`echo "$current_size*1024"|bc`
								reduce_size=`echo "$size-$r_size"|bc`
								reduce_unit="M"
							elif [[ "$current_unit" == "MB" && "$r_unit" == "G" ]]
							then
								printf " Current LV size is in MB. Given new size is in GB. can not do reduce LV.\n"
								return							
							else
								printf " Else part \n"
							fi
                        			        break
	                        		fi
		        	        fi
				fi
			fi
		fi
	done
	       printf " Are you sure want to reduce $lvm  LV [y/n]? : "
       	       read confrm
	       if [[ "$confrm" == "y" ]]
               then
			fcheck=`echo $lvname|awk 'gsub("/"," "); {print  $3}'`
		        fsname_check=`mount 2>/dev/null |grep "$fcheck"`
		        if [[ "$fsname_check" == "" ]]
		        then
               		       printf "$lvname is not mounted , reducing the $lvname \n"
			else
                	        printf "Unmounting the $mount_point LV ...\n"
				umount $lvm  2> /dev/null
        		        if [ $? -eq 0 ]
                		then
                        	        printf " $mount_point  unmounted successfully\n"
					unmount_flag=1
					# reduce the FS residing on the LV
					e2fsck -f $lvm  2> /dev/null
					if [ $? -eq 0 ]
                                        then
						printf " $lvm e2fsck executed successfully..\n "
						# resize the filesystem on the logical volume 
						resize2fs $lvm $nrsize  2> /dev/null
						if [ $? -eq 0 ]
						then
							printf " $lvm resize2fs executed successfully..\n"					
							# Reduce the logical volume 
						else
							printf " $lvm resize2fs issues are there..\n"
							if [[ "$unmount_flag" == "1" ]]
							then
								# printf "Mounting $mount_point\n"
								mount $lvm $mount_point	  2> /dev/null
							fi
						fi

					else
						printf " $lvm e2fsck issues are there..\n"
					fi
        	                else
                	               	printf "Issue with unmounting $mount_poin LV\n"
			 	fi	
			fi
					finale_size=`echo $reduce_size  $reduce_unit |  awk '{ sub (/ /,""); print $1 }'`
					# printf "Reduce Size :- $reduce_size \n"
					# printf "Reduce Unit :- $reduce_unit \n"
					# printf "Finale size in reduce lv $finale_size \n"
					# printf " lvreduce -L -$finale_size  $lvm \n"
					lvreduce -L -$finale_size  $lvm  2> /dev/null
	                       	        if [ $? -eq 0 ]
        	                       	then
	          	        	     printf "$lvm LV reduced by $rsize successfully\n"
		                        else
                		               printf " Issue with reducing  $lvm LV by $rsize size\n"
						
							if [[ "$unmount_flag" == "1" ]]
							then
								mount $lvm $mount_point	  2> /dev/null
							fi
		                        fi
	        elif [[ "$confrm" == "n" || "$confrm" == ""  ]]
        	then
                        printf " Reduce LV has not confirmed...Exiting from Reduce LV\n"
	        fi
}

##########################################################################
# rhl3_more_lvm function is for , based on the users menu option, calling the rhl3 lvm functions 
##########################################################################
rhl3_more_lvm ( )
{
	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "RHL3 Logical Volume Management"
	echo -e "\033[0m"
        RHL3_LVM_MENU[0]="1) List physical Volumes "
        RHL3_LVM_MENU[1]="2) List Volume Group"
        RHL3_LVM_MENU[2]="3) Create Volume Group"
        RHL3_LVM_MENU[3]="4) Extend Volume Group"
        RHL3_LVM_MENU[4]="5) List Logical Volume"
        RHL3_LVM_MENU[5]="6) Mount Logical Volume"
        RHL3_LVM_MENU[6]="7) Unmount Logical Volume"
        RHL3_LVM_MENU[7]="8) Create Logical Volume"
        RHL3_LVM_MENU[8]="9) Extend Logical Volume"
        RHL3_LVM_MENU[9]="r) Command prompt"
 	ITEMCNT_PERF="${#RHL3_LVM_MENU[@]}"
        for MENULINE in "${RHL3_LVM_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
	printf "\n Enter your choice: "
                get_opt
                ret=$?
		case $ret in 
		1)
			clear 
			print_header
			echo -e "\033[1m"
		 	tput cup  15 15 ; echo "List physical Volumes "
			echo -e "\033[0m"
			#printline
			rhl3_get_pvs
		        moveon
			audit_log "1  from  more_lvm " RHL3_LIST_PVS
			rhl3_more_lvm
			;;
		2)			
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo " List Volume Group "
			echo -e "\033[0m"
			#printline
			rhl3_get_vg_list
		        moveon
			audit_log "2  from  more_lvm " RHL3_LIST_VGS
			rhl3_more_lvm
			;;
		3) 
			clear 
			print_header
			echo -e "\033[1m"
		 tput cup  15 15 ; echo "Create Volume Group "
			echo -e "\033[0m"
			#printline
			rhl3_create_vg
		        moveon
			audit_log "3  from  more_lvm " RHL3_Create_VGS
			rhl3_more_lvm
			;;
		4)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo "Extend Volume Group "
			echo -e "\033[0m"
			#printline
			rhl3_extend_vg
		        moveon
			audit_log "4  from  more_lvm " RHL3_Extend_VGS
			rhl3_more_lvm
			;;
		5)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo "List Logical Volume "
			echo -e "\033[0m"
			#printline
			rhl3_get_lv_list
		        moveon
			audit_log "7  from  more_lvm " RHL3_LIST_LV
			rhl3_more_lvm
			;;
		6)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo " Mount Logical Volume "
			echo -e "\033[0m"
			#printline
			rhl3_fs_mount
		        moveon
			audit_log "8  from  more_lvm " RHL3_Fs_mount
			rhl3_more_lvm
			;;
		7)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo "UnMount Logical Volume "
			echo -e "\033[0m"
			#printline
			rhl3_fs_unmount
		        moveon
			audit_log "9  from  more_lvm " RHL3_Fs_unmount
			rhl3_more_lvm
			;;
		8)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo "Create Logical Volume "
			echo -e "\033[0m"
			#printline
			rhl3_create_lv
		        moveon
			audit_log "10  from  more_lvm " RHL3_Create_Lv
			rhl3_more_lvm
			;;
		9)
			clear 
			print_header
			echo -e "\033[1m"
			 tput cup  15 15 ; echo "Extend Logical Volume "
			echo -e "\033[0m"
			#printline
			rhl3_extend_lv
		        moveon
			audit_log "11 from  more_lvm " RHL3_Extend_LV
			rhl3_more_lvm
			;;
               $CANCEL)
                        stty sane
                        return
                        ;;
               $EXIT)
                        exit_admin
                        ;;
	       $DASHBOARD)
                        dash_board
                        ;;
	       $CPROMPT) run_cmd;;
		$HELP)
			MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A11 "LVM_MGMT:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;
               $REFRESH)
                        return
                        ;;
	      m|M|*)
			menu
			#return
		        ;;
	esac
}

#####################################################
# lvm_detail function is for displaying VG,PV,LV details
#####################################################
lvm_detail ()
{
	# printline
	echo -e "\033[1m"
	printf " Logical Volume Management\n"
	echo -e "\033[0m"
	# printline
	print_header
	more_lvm
}

#####################################################
# over_all_mem function is for displaying Overall Memory Utilization
#####################################################
over_all_mem ()
{
 	# printline
   	printf "\e[1m \n\n \t\t\t Overall Memory Utilization (Units are in MB ) \n"
                printf "\e[0m"
		# printline
              	printf " %-22s %-10s %-10s %-10s %-10s %-10s \n" "            Total"  "Used" "Free" "Shared" "Buffers" "Cached"
		# printf " %-10s %-10s %-10s %-10s %-10s %-10s \n" \t "Total"  "Used" "Free" "Shared" "Buffers" "Cached"
                #tput cup 38 12; echo -e "\033[1m Total"
                #tput cup 38 23; echo -e "\033[1m Used"
                #tput cup 38 35; echo -e "\033[1m Free"
                #tput cup 38 43; echo -e "\033[1m Shared"
                #tput cup 38 55; echo -e "\033[1m Buffers"
                #tput cup 38 65; echo -e "\033[1m Cached"
                echo -e "\033[0m"
		# printline
                TMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $2}'`
                UMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $3}'`
                FMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $4}'`
                SMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $5}'`
                BufferMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $6}'`
                CacheMem=`free -m 2>/dev/null | grep -i "Mem" 2>/dev/null| awk '{print $7}'`
                TSwap=`free -m  2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $2}'`
                USwap=`free -m  2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $3}'`
                FSwap=`free -m  2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $4}'`
                SSwap=`free -m  2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $5}'`
                BufferSwap=`free -m 2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $6}'`
                CacheSwap=`free -m 2>/dev/null | grep -i "Swap" 2>/dev/null| awk '{print $7}'`
                printf "%-12s %-10s %-10s %-10s %-10s %-10s %-10s \n" "Memory"  "$TMem"  "$UMem" "$FMem" "$SMem" "$BufferMem" "$CacheMem"
                printf "\n"
                printf "%-12s %-10s %-10s %-10s %-10s %-10s  \n" "Swap"   "$TSwap"  "$USwap" "$FSwap" "$SSwap" "$BufferSwap" "$CacheSwap"
	# free -mo   2> /dev/null
	# printline
        printf "Press enter to continue"
        read in
}

#####################################################
# This is for printing the line
#####################################################
printline ()
{
        printf "\n____________________________________________________________________________________________________________________________________\n\n"
}

#####################################################
# audit_log function is for logging mechanisam 
#####################################################
audit_log ()
{
	ts=`date "+%d %h %Y %H:%M:%S"`
        opt="$1"
        text="$2"
        printf "%-25s %-20s %-20s\n" "$ts" "$user ($eid)" "menu option selected $opt ($text)" >> $AUDLOG

}

#####################################################
#admin_log is for logging the commands which are all executed in the Run a command option
#####################################################
admin_log ()
{
	 ts=`date "+%d %h %Y %H:%M:%S"`
        c=$@
        printf "%-25s %-20s %-20s\n" "$ts" "$user ($eid)" "$c" >> $ADMLOG
}

#####################################################
# print_header is for printing the header informations line, OS type, Version, Manufacturer,uptimes etc..
#####################################################
print_header ()
{
        clear
        sys_t=`date`
        # HEAD_1[0]="System time : $sys_t"
        printf "\e[1m"
        tput cup 1 ${HDRBEGIN}; echo "${HEADER}"
#        printf "____________________________________________________________________________________________________________________________________\n\n\n"
        if [[ $user_id != "root" ]]
        then
                tput cup 3 1; echo "Mode: Non Root"
        else
                tput cup 3 1; echo  "Mode: Root"
        fi
        LINE=0;COL=0
        for HEADLINE1 in "${HEAD_1[@]}"
        do
                tput cup $(($LINE+5)) $COL; echo "${HEADLINE1}"
                let LINE=LINE+1
        done
        LINE=0;COL=50
        for HEADLINE2 in "${HEAD_2[@]}"
        do
                tput cup $(($LINE+5)) $COL ; echo "${HEADLINE2}"
                let LINE=LINE+1
        done
 #        printf "_______________________________________________________________________________________________________________________________________\n\n\n"
        printf "\e[0m"
        tput cup $((SCRHIG-6)) 0 ; echo "F1|[H]=Help     F2|[D]=Dashboard     F3|[C]=Cancel     F5=Refresh     F10|[Q]=Exit"
        tput cup $((SCRHIG-5)) 0 ; echo  "__________________________________________________________________________________"
        tput cup $((SCRHIG-3)) 0 ; echo  ">> For technical support, please check Adminstrator Who Knows Scripting <<"


}

#####################################################
# fs_detail is for priting the Filesystem details
#####################################################
fs_detail ()
{
 	print_header
        MENU_ROW="15"
        MENU_COL="10"
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 20 ; echo  "Filesystem usage"
	echo -e "\033[0m"
  	# printline
	# tput ed
 	# df -hP 2>/dev/null
 
 		#	printf "_________________________________________________________________________________________________________\n\n"
 			echo -e "\033[1m"
 			printf "%-32s %-12s %-15s %-15s %-15s %-20s\n" "FileSystem" "Size" "Used" "Avail" "Use%"  "Mounted on"  
 			echo -e "\033[0m"
 		#	printf "_________________________________________________________________________________________________________\n\n"
 			df -hP 2>/dev/null | grep -v "Used"  > /$TMP_DIR/df_list
 			while read lines
 			do
 			# 	printf "$lines\n"
 				fsname=`echo $lines | awk '{print $1}'`
 				size=`echo $lines | awk '{print $2}'`	
 				used=`echo $lines | awk '{print $3}'`	
 				avail=`echo $lines | awk '{print $4}'`	
 				use=`echo $lines | awk '{print $5}'`	
 				mon=`echo $lines | awk '{print $6}'`	
 			       	printf "%-32s %-12s %-15s %-15s %-15s %-20s" "$fsname"  "$size" "$used" "$avail" "$use" "$mon" 
 			       	printf "\n"
 			done < "/$TMP_DIR/df_list"
 			rm -f /$TMP_DIR/df_list 2>/dev/null
 		#	printf "_________________________________________________________________________________________________________\n\n"
# 	#printline
  more_fs_tasks ()
 {
                is_fs ()
                {
                        f=$1
			cat /etc/fstab 2>/dev/null| awk '{ print $2}' | grep -Fx $f
                        ( [[ $? -eq 0 ]] && return 0 || return 1 )
                }

		 print_header
        MENU_ROW="15"
        MENU_COL="10"
        echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "File system & Related task"
        echo -e "\033[0m"
        FS_MENU[0]="1) Show all mounted filesystems "
        FS_MENU[1]="2) Top directories/files as per the disk usage"
        FS_MENU[2]="3) 10 largest files"
        FS_MENU[3]="4) Find files older than __ days"
        FS_MENU[4]="5) Compress a file"
        FS_MENU[5]="6) Delete file"
        FS_MENU[6]="7) Uncompress a file"
        FS_MENU[7]="r) Command prompt"
        # FS_MENU[7]="8) Go back to main menu"
        ITEMCNT_PERF="${#FS_MENU[@]}"
        for MENULINE in "${FS_MENU[@]}"
        do
                tput cup $MENU_ROW $MENU_COL ; echo "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
                printf "\nEnter Your choice:"
                #read j
                get_opt
                ret=$?
                case $ret in
		1)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t Mounted Filesystems \n\n"
			echo -e "\033[0m"
		 	# printline
			# printf "_________________________________________________________________________________________________________\n\n"
			 # df -ah 2>/dev/null
			echo -e "\033[1m"
			printf "%-32s %-32s %-33s %-38s \n" "FileSystem"  "Mounted on" "Type" "Mode" 
			echo -e "\033[0m"
		 	# printline
			# printf "_________________________________________________________________________________________________________\n\n"
			mount | awk '{print $1 " " $3 " " $5 " " $6 }' > /$TMP_DIR/mount_list
			while read lines
			do
			# 	printf "$lines\n"
				fsname=`echo $lines | awk '{print $1}'`
				mton=`echo $lines | awk '{print $2}'`	
				type=`echo $lines | awk '{print $3}'`	
				mode=`echo $lines | awk '{print $4}'`	
			       	printf "%-32s %-32s %-30s %-26s" "$fsname"  "$mton" "$type" "$mode" 
			       	printf "\n"
			done < "/$TMP_DIR/mount_list"
			rm -f /$TMP_DIR/mount_list 2>/dev/null
			# printf "_________________________________________________________________________________________________________\n\n"
			audit_log "1 from more_fs_tasks" All_mounted_Filesystems
		#	printf "_________________________________________________________________________________________________________\n\n"
		 	# printline
			printf "Press enter to continue"
                        read in
                        more_fs_tasks
			;;	
		 2)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t Top directories/files as per the disk usage \n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do
	                        printf "Enter the Filesystem/Directory or q to exit: "
        	                read fs
				if [[ "$fs" == "" ]]
				then
					continue
				elif [[ "$fs" == "q" ]]
				then
					more_fs_tasks
					return
				else 
					break
				fi
			done
			if [ -d "$fs" ]
                        then	
				while ( true )
				do
	                	        printf "Enter Number of Files to display: "
        	        	        read n 
					nodigits="$(echo $n | sed 's/[[:digit:]]//g')"
					if [[ "$n" == "" ]]
					then
						continue
					elif [[ "$n" == "q" ]]
					then
						more_fs_tasks
						return
					elif [ ! -z $nodigits ] ; then
					  	echo "Invalid number format! Only digits." >&2
						continue
					else 
						break
					fi
				done
	                 else
        	                printf "Invalid FS/Directory $fs ! \n"
				# printline
                	        printf "Press enter to continue"
                                read in
                              	more_fs_tasks
	                 fi
				if [[ "$fs" == "/" ]]
				then
					fs=""
				fi	
				du -sk $fs/* 2>/dev/null | sort -rn | while read size fname
				do
				         for unit in k M G T P E Z Y
				         do
				                if [ $size -lt 1024 ]
				                then
				                         echo -e "${size}${unit}\t${fname}" >> /$TMP_DIR/du_high
				                         break
				                 fi
				         size=$((size/1024))
				         done
				 done
				if [ ! -f /$TMP_DIR/du_high ]
				then
					# printline
					printf "There is no file in this FS/Dir \n"
					# printline
                                	printf "Press enter to continue"
	                                read in
        	                        more_fs_tasks
				else
					# printline
					echo -e "\033[1m"
					printf "Size \t File/Dir\n"
					echo -e "\033[0m"
					# printline
					cat /$TMP_DIR/du_high 2>/dev/null | head -$n
					rm -f /$TMP_DIR/du_high 2>/dev/null
				fi
				audit_log "2 from more_fs_tasks" Top_dirs_files_as_per_disk_usage
				# printline
                                printf "Press enter to continue"
                                read in
                                more_fs_tasks
                        	;;
		 3)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t Finding largest files \n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do
               			printf "Enter the Filesystem/Directory or q to exit: "
                        	read fs
				if [[ "$fs" == "" ]]
				then
					continue
				elif [[ "$fs" == "q" ]]
				then
					more_fs_tasks
					return
				else
					break
				fi
			done
			if [ -d "$fs" ]
                        then	
			while ( true )
			do
	                        printf "Enter Number of Files to display: "
        	                read n 
				nodigits="$(echo $n | sed 's/[[:digit:]]//g')"
				if [[ "$n" == "" ]]
				then
					continue
				elif [[ "$n" == "q" ]]
				then
					more_fs_tasks
					return
				elif [ ! -z $nodigits ] ; then
				  	echo "Invalid number format! Only digits." >&2
					continue
				else 
					break
				fi
			done
			else
        	                printf "Invalid FS/Dir $fs! \n"
                	        printf "Press enter to continue"
                                read in
	                        more_fs_tasks
        	         fi
			
				files=`find $fs  -xdev -ls 2> /dev/null | awk '{print $7 "\t" $11}' | sort -nr|head -$n  2> /dev/null`
				if [[ "$files" != "" ]]
				then
				# find $fs  -type f  -exec ls -ld {} \; |sort -rnk5|head -$n> /$TMP_DIR/find_op
	                        # printline
				echo -e "\033[1m"
				printf " Size (Bytes) \t FileName\n"
				echo -e "\033[0m"
	                        # printline
				find $fs  -xdev -ls 2> /dev/null | awk '{print $7 "\t" $11}' | sort -nr|head -$n  2> /dev/null
				audit_log "3 from more_fs_tasks" Largest_files
				# printline
		                printf "Press enter to continue"
        		        read in
                		more_fs_tasks
				else
					# printline
					printf "No files found\n"
					# printline
			                printf "Press enter to continue"
        			        read in
                			more_fs_tasks
				fi
                	 ;;
		  4)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t Find files older than __ days \n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do
	
	                 printf "Enter the FS/Directory or q to exit : "
        	         read fs
			if [[ "$fs" == "" ]]
			then
				continue
			elif [[ "$fs" == "q" ]]
			then
				more_fs_tasks
				return
			else
				break
			fi
			done
			 
                	 if [ -d "$fs" ]
                         then
				while ( true )
				do
                	               	printf "No. of days older: "
		        	        read days
					nodigits="$(echo $days | sed 's/[[:digit:]]//g')"
					if [ ! -z $nodigits ] ; then
					  	echo "Invalid number format! Only digits." >&2
						continue
					else
						break
					fi
				done
				ofiles=`find $fs -type f -mtime +$days -ls 2>/dev/null`
				if [[ "$ofiles" != "" ]]
				then
                	        a=` printline; printf "Size (Bytes) \t Filename\n"; printline; find $fs -type f -mtime +$days -ls 2>/dev/null | awk '{print $7 "\t " $11}'`
				printf "$a" | less
                                # find $fs -type f -mtime +$days 2>/dev/null|xargs -i ls -l {}|awk '{print $5 "\t\t" $9}' | less

                	        # printline
        	                # printf "Size (Bytes) \t Filename\n"
                	        # printline
				#  find $fs -type f -mtime +$days -ls 2>/dev/null | awk '{print $7 "\t " $11}' | less
				audit_log "4 from more_fs_tasks" Older_files
				# printline
                	        printf "Press enter to continue"
                                read in
                               	more_fs_tasks
				else
					# printline
					printf "No files found\n"
					# printline
			                printf "Press enter to continue"
        			        read in
                			more_fs_tasks
				fi
	                 else
        	                printf "Invalid $fs! \n"
				# printline
                	        printf "Press enter to continue"
                                read in
                              	more_fs_tasks
	                 fi
        	         ;;
		5)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t File Compression\n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do
			printf "Enter File name (provide absolute path) to be compressed or q to exit: "
                	read file
			if [[  "$file" == "q" ]]
                        then
				more_fs_tasks
				return
			fi
                        if [ ! -f $file ]
	                then
        	        	printf "$file doesn't exists! \n"
                	        #printf "Press enter to continue"
                        	#read in
				continue
                                more_fs_tasks
	                else
			if [[ "$file" == "" ]]
			then
				printf "File name should not empty\n"
				continue
			else
				break
                        fi
			fi
			done
			
			while ( true )
			do
				printf "Enter the compression type (gzip,bzip2,zip,tar ) or q to exit: "
	                	read ctype
				if [[  "$ctype" == "q" ]]
                        	then
					more_fs_tasks
					return
				fi
                        	if [[ "$ctype" != "zip" &&  "$ctype" != "gzip" &&  "$ctype" != "bzip2" &&  "$ctype" != "tar"   ]]
	                	then
        	        		printf "Invalid compression type $ctype !\n"
					continue
                        	        more_fs_tasks
	                	else
				if [[ "$ctype" == "" ]]
				then
					printf "Compression type should not empty\n"
					continue
				else
					break
                        	fi
				fi
			done
			if [[ "$ctype" == "gzip" ]]
			then
				osize=`du -sh $file | awk '{print $1}'`
				gzip $file 2>/dev/null
				nfile=`echo $file".gz"`
				tio=`gzip -l $nfile |grep -v "ratio"|awk '{print $3}' `
                	        if [[ $? -eq 0 ]]
                                then
                              	# printf "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size with $tio ratio successfully.\n"
					# I can not print "%" symbol in the printf. thats y used echo 
                              		echo -e  "$file compressed successfully.\n"
					printf "File Old size : \t $osize\n"
					printf "File New size : \t  `du -sh $nfile | awk '{print $1}'` \n"
					echo -e  "Compression Ratio : \t $tio \n"
					 audit_log "5 from more_fs_tasks" Compress_files
                	         fi
			elif [[ "$ctype" == "zip" ]]
			then
				osize=`du -sh $file | awk '{print $1}'`
				nfile=`echo $file".zip"`
				zip $nfile $file 2>/dev/null
				# tio=`gzip -l $nfile |grep -v "ratio"|awk '{print $3}' `
                	        if [[ $? -eq 0 ]]
                                then
                              	# printf "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size with $tio ratio successfully.\n"
					# I can not print "%" symbol in the printf. thats y used echo 
                              		 echo -e  "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size successfully.\n"
                              		echo -e  "$file compressed successfully.\n"
					printf "File Old size : \t $osize\n"
					printf "File New size : \t  `du -sh $nfile | awk '{print $1}'` \n"
					#echo -e  "Compression Ratio : \t $tio \n"
					 audit_log "5 from more_fs_tasks" Compress_files
                	         fi
			elif [[ "$ctype" == "bzip2" ]]
			then
				osize=`du -sh $file | awk '{print $1}'`
				bzip2 $file 2>/dev/null
				nfile=`echo $file".bz2"`
			#	tio=`gzip -l $nfile |grep -v "ratio"|awk '{print $3}' `
                	        if [[ $? -eq 0 ]]
                                then
                              	# printf "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size with $tio ratio successfully.\n"
					# I can not print "%" symbol in the printf. thats y used echo 
                              		 echo -e  "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size  successfully.\n"
                              		echo -e  "$file compressed successfully.\n"
					printf "File Old size : \t $osize\n"
					printf "File New size : \t  `du -sh $nfile | awk '{print $1}'` \n"
					# echo -e  "Compression Ratio : \t $tio \n"
					 audit_log "5 from more_fs_tasks" Compress_files
                	         fi
			elif [[ "$ctype" == "tar" ]]
			then
				osize=`du -sh $file | awk '{print $1}'`
				nfile=`echo $file".tgz"`
				tar -cvzf $nfile $file 2>/dev/null
				# tio=`gzip -l $nfile |grep -v "ratio"|awk '{print $3}' `
                	        if [[ $? -eq 0 ]]
                                then
                              	# printf "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size with $tio ratio successfully.\n"
					# I can not print "%" symbol in the printf. thats y used echo 
                              		 echo -e  "$file compressed from $osize  size to `du -sh $nfile | awk '{print $1}'` size successfully.\n"
                              		echo -e  "$file compressed successfully.\n"
					printf "File Old size : \t $osize\n"
					printf "File New size : \t  `du -sh $nfile | awk '{print $1}'` \n"
					# echo -e  "Compression Ratio : \t $tio \n"
					 audit_log "5 from more_fs_tasks" Compress_files
                	         fi
			fi
			# printline
	                printf "Press enter to continue"
        	        read in
                	more_fs_tasks
                        ;;
		 6)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t File Deletion\n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do		
       		       printf "File name (provide full path) to be deleted or q to exit: "
                       read file
			if [[ "$file" == "" ]]
			then
				continue
			elif [[ "$file" == "q" ]]
			then
				more_fs_tasks
				return
			elif [ ! -f $file ]
	                then
        	        	printf "$file doesn't exists! \n"
                	        #printf "Press enter to continue"
                        	#read in
                                # more_fs_tasks
				continue
	                else
				break
			fi
			done
        	                rm -i $file 2>/dev/null
                	        if [[ $? -eq 0 ]]
                                then
                               	        printf "$file deleted successfully.\n"
					audit_log "6 from more_fs_tasks" Delete_files
	                         fi
			# printline
                	printf "Press enter to continue"
                        read in
	                more_fs_tasks
       		        ;;
		7)
			tput ed
 			# printline
			echo -e "\033[1m"
			printf "\t\t\t File Uncompression \n\n"
			echo -e "\033[0m"
		 	# printline
			while ( true )
			do
				printf "Enter File name (provide absolute path) to be uncompressed or q to exit: "
	        	        read file
				file_ext=$(echo $file |awk -F . '{if (NF>1) {print $NF}}')
				if [[ "$file" == "" ]]
				then
					continue
				elif [[ "$file" == "q" ]]
				then
					more_fs_tasks
					return
				elif [ ! -f $file ]
		                then
        		        	printf "$file doesn't exists! \n"
                		        #printf "Press enter to continue"
                        		#read in
                                	# more_fs_tasks
					continue
	                        elif [[ "$file_ext" != "gz" &&  "$file_ext" != "bz2" &&  "$file_ext" != "zip" &&  "$file_ext" != "tgz"   ]]
	 	 	        then
					printf " $file is not a compressed file\n";
					continue
		                else
				
					break
				fi
			done
		
			if [[  "$file_ext" == "gz" ]]
			then
                        	gunzip $file  2>/dev/null
	                	if [[ $? -eq 0 ]]
        	        	then
                			printf "$file Uncompressed successfully.\n"
                        	        audit_log "5 from more_fs_tasks" UnCompress_files
	                	fi
			elif [[  "$file_ext" == "zip" ]]
			then
                        	unzip $file  2>/dev/null
	                	if [[ $? -eq 0 ]]
        	        	then
                			printf "$file Uncompressed successfully.\n"
                        	        audit_log "5 from more_fs_tasks" UnCompress_files
	                	fi
			elif [[  "$file_ext" == "tgz" ]]
			then
                        	tar -xvzf  $file  2>/dev/null
	                	if [[ $? -eq 0 ]]
        	        	then
                			printf "$file Uncompressed successfully.\n"
                        	        audit_log "5 from more_fs_tasks" UnCompress_files
	                	fi

			elif [[  "$file_ext" == "bz2" ]]
			then
                        	bunzip2 $file  2>/dev/null
	                	if [[ $? -eq 0 ]]
        	        	then
                			printf "$file Uncompressed successfully.\n"
                        	        audit_log "5 from more_fs_tasks" UnCompress_files
	                	fi
			fi
			# printline
                	 printf "Press enter to continue"
                         read in
	                 more_fs_tasks
        	         ;;
                         $CANCEL)
                         stty sane
                         return
                         ;;
			$HELP)
			 	MENU_ROW="15"
	                       MENU_COL="10"
	                        tput civis
         	               help_item="${1}"
                	        print_header
	                        arr[0]=`grep -A9 "FS_DETAIL:" /$ETC_DIR/help`
        	                tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                	        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        	get_opt
	                        tput cnorm
        	                ;;
		      $DASHBOARD)
			dash_board
			;;	
                         $EXIT)
                         exit_admin
                         ;;
			 $CPROMPT) run_cmd;;
                         $REFRESH)
                         more_fs_tasks
                         return
                         ;;
                       m|M|*)
               		#  print_header
	                 menu
			#return
			 ;;

                esac
                # # printline
}
	 printf "\nMore tasks?:(y/n)"
        read i
        if [[ $i == "y" || $i == "Y" ]]
        then
                more_fs_tasks
        elif [[ $i == "n" || $i == "N" ]]
        then
                menu
        fi
}

#####################################################
# run_cmd is for executing the commands in the command prompt
#####################################################
run_cmd ()
{
        cd $HOME
       # print_header
        printf "\nRun a command of your choice, type "quit" or exit to exit the command mode \n"
        loop_cmd ()
        {
                ( [[ "${user_id}" != "root" ]] && printf "$user_id@admin>$" || printf "$user_id@admin>#" )
                read cmd
                cmd1=`echo $cmd|awk '{print $1}'`
                if [[ "${cmd}" == "quit" || "${cmd}" == "exit" ]]; then
                        menu

                elif [[ "${cmd1}" == "shutdown" || "${cmd1}" == "reboot" || "${cmd1}" == "halt" ]]
                then
                        if [[ "${user_id}" != "root" ]]
                        then
                                printf "You should be root to perform this operation\n"
                                loop_cmd
                        else
                                printf "Your are about to shutdown or reboot the system `hostname`!!\n"
                                printf "Are you sure want to continue? (y/n):"
                                read in
                                if [[ $in == "y" || $in == "Y" ]]
                                then
                                        printf "Please provide the Change number:"
                                        read ch
                                        for i in $ch
                                        do
                                                if [[ "$i" != CH????? ]]
                                                then
                                                        printf "Invalid Change Number: $ch\n"
                                                        loop_cmd
                                                else
                                                        admin_log $cmd
                                                        printf "Executing $cmd...\n"
                                                        eval $cmd
                                                fi
                                        done
                                else
                                        loop_cmd
    fi
                        fi
                else
                        admin_log $cmd
                        eval $cmd
                        loop_cmd
                fi
        }
        loop_cmd
}

#####################################################
#exit_admin function
#####################################################
exit_admin ()
{
        #rm -f /$TMP_DIR/prtconf_admin_$$ > /dev/null 2>&1
        #rm -f /$TMP_DIR/cpu_usage_$$ > /dev/null 2>&1
        #rm -f /$TMP_DIR/vios_tmp > /dev/null 2>&1
        tput cup  $((SCRHIG-1)) 1 ; echo "Have a nice day!!!"
        printf "\n"
        #refresh
        exit 0
}

#####################################################
#user_detail function is for displaying the available user details
#####################################################

user_detail ()
{
        print_header
	tput ed
        # echo -e "\033[1m"
        # tput cup  15  15 ; echo  "User Details"
        # echo -e "\033[0m"
        Udetail=`printline; printf "%-15s %-10s %-10s %-20s %-30s %-60s \n" "UserName" "User ID" "Group ID" "User ID Info" "Home" "Shell";printline;cat /etc/passwd 2>/dev/null|awk '{IFS=":";gsub(/::/,":-:");gsub(/:/," ");printf "%-15s %-10s %-10s %-20s %-30s %-60s \n", $1,$3,$4,$5,$6,$7}'`
        echo "$Udetail" | less
        printf "Press enter to continue"
        read in
}


cluster_details ()
{
        print_header
	#tput ed
        MENU_ROW="15"
        MENU_COL="10"
	cls=`clustat  2>/dev/null | grep -i "service" `
	# if [[ "$cls" == "" ]]
	if [[ "$?" != "0" ]]
	then
		tput cup $((MENU_ROW-2)) 15 ; echo "Cluster has not configured"

	else
		cat /etc/cluster/cluster.conf > /$TMP_DIR/cluster.ip
		no_node=`cat /$TMP_DIR/cluster.ip | grep '<clusternode ' | wc -l `
		cluster_names=`cat /$TMP_DIR/cluster.ip |  grep '<clusternode' | awk '{gsub(/name="/,"");gsub(/"/,""); gsub(/nodeid=/,""); print $2 "    " $3 } '`
		# node_id=`cat cluster.ip |  grep '<clusternode' | awk '{gsub(/nodeid="/,"");gsub(/"/,""); print $3}'`
		service_name=`cat /$TMP_DIR/cluster.ip | grep '<service ' | awk '{gsub(/name="/,"");gsub(/"/,"");print $4 }'`
		ip_address=`cat /$TMP_DIR/cluster.ip |  grep '<ip address=' | awk '{gsub(/address="/,"");gsub(/"/,""); print $2 }'`
		fs_type=`cat /$TMP_DIR/cluster.ip | grep 'fstype=' | awk '{gsub(/force_fsck="0"/,"");gsub(/fstype="/,"");gsub(/"/,"");print $5 }'`
		# fs_type=`cat /$TMP_DIR/cluster.ip | grep '<fs device=' | awk '{gsub(/fstype="/,"");gsub(/"/,"");print $6 }'`
		mount_point=`cat /$TMP_DIR/cluster.ip | grep '<fs device=' | awk '{gsub(/mountpoint="/,"");gsub(/"/,"");print $7 }'`
		s_run_on=`clustat 2>/dev/null | grep 'service:' | awk '{ print $2 }'`
		if [[ "$s_run_on" == "" ]]
		then
			s_run_on="  - "
	
		fi
		if [[ "$ip_address" == "" ]]
		then
			ip_address="-"
		fi
		if [[ "$fs_type" == "gfs2" ]]
		then
			fs_type="Load Balancer"
			# tput cup $((MENU_ROW-2)) 15 ; echo "GFS cluster not yet integrated in the script"
		else
			fs_type="High Availability"
		fi
		CLUS_L[1]="No.of.Nodes : $no_node"
		CLUS_L[2]="Service Name : $service_name"
		CLUS_R[1]="IP Address : $ip_address"
		CLUS_R[1]="Runs on: $s_run_on"
		CLUS_R[2]="Type of Cluster : $fs_type"
		echo -e "\033[1m"
        	tput cup  $((MENU_ROW-2)) 15 ; echo  "Cluster Information"
		printf "\n\n"
		# printline
		 LINE=11;COL=0
        for HEADLINE1 in "${CLUS_L[@]}"
        do
                tput cup $(($LINE+5)) $COL; echo "${HEADLINE1}"
                let LINE=LINE+1
        done
        LINE=11;COL=50
        for HEADLINE2 in "${CLUS_R[@]}"
        do
                tput cup $(($LINE+5)) $COL ; echo "${HEADLINE2}"
                let LINE=LINE+1
        done
		echo -e "\033[0m"

	# 	printf "\e[1m"
	# 	printf "%-10s %-15s %-18s  %-18s %-20s %-25s \n" "#Nodes" "ServiceName" "Running on" "IP Address" "Fstype" "MountPoint" 
	# 	printf "\e[0m"
	# 	printf "%-10s %-15s %-18s  %-18s %-20s %-25s \n" "$no_node" "$service_name" "$s_run_on" "$ip_address" "$fs_type" "$mount_point" 

		
        MENU_ROW="19"
        MENU_COL="13"
        CLUS_MENU[0]="1) Cluster Nodes"
        CLUS_MENU[1]="2) Application Details"
         CLUS_MENU[2]="r|R) Command Prompt"
        ITEMCNT="${#CLUS_MENU[@]}"
        for MENULINE in "${CLUS_MENU[@]}"
        do
                tput cup  $MENU_ROW $MENU_COL ; echo  "${MENULINE}"
                let MENU_ROW=MENU_ROW+1
        done
	printf "\n\n"
	printf "Enter Your Choice:"
	#read input
	sig_trap
        get_opt
        ret=$?
case $ret in
		1)
		clear   		
		print_header
		echo -e "\033[1m"
        	tput cup  15 15 ; echo  "Cluster Nodes"
		printf "\n\n"
		# printf "\t\t\t List of Volume Groups "
		# printline
        	# get_vg_list
		# clustat
		 printf "\nMember Name          ID "
		echo -e "\033[0m"
		printf "$cluster_names \n"
		# printline
	        moveon
		audit_log "1  from  cluster_details " Cluster_details
		cluster_details
	        ;;
		2)
		clear   		
		print_header
		echo -e "\033[1m"
        	tput cup  15 15 ; echo  "Application details"
		echo -e "\033[0m"
		printf "\n\n"
		printf "Service Name : $service_name \n"
		printf "IP Address   : $ip_address \n"
		printf "Mount point  : $mount_point  \n"
		# printline
	        moveon
		audit_log "2  from  Application_details" Cluster_details
		cluster_details
			;;	
		$CPROMPT)  run_cmd;audit_log 8 Run_a_Command;;
		#q|Q) exit 0 ;;
                $EXIT) exit_admin;;
		$HELP)
			 MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A2 "CLUSTER_MENU:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;
		$DASHBOARD)
                        dash_board
                        ;;
		 $REFRESH) cluster_details
				return;;
		*) continue ;;
	esac
		fi
	# printline
        printf "Press enter to continue"
        read in

}
##### Modified By Amit 
####################################

function get_opt
{
	# stty erase "^?"
	stty erase ^?
	# stty erase "^H"
        tty_save=$(stty -g)
       stty cs8 -icanon min 10 time 1
#        stty cs8 -icanon -echo min 10 time 1
        
        count=0
        while :; do
                count=$((count+1))
                # key=$(dd bs=11 count=1 2> /dev/null | Get_odx)
                # key=$(dd bs=11 count=1 2> /dev/null | Get_odx)
                # key=$(dd bs=11 count=2 2> /dev/null | Get_odx)
                key=$(dd bs=10 count=1 2> /dev/null | Get_odx)
	# 			printf " \n"
       #          echo -n "key=\"$key\""
	#			printf " \n"
                case "$key" in
                        "$ttyf1"|"$tty_h"|"$tty_H"|"$f1"|"$t_h"|"$t_H")
                        stty sane
                        return $HELP
                        break;;
                        "$tty_f2"|"$tty_d"|"$tty_D"|"$f2"|"$t_D")
                        stty sane
                        return $DASHBOARD
                        break;;
                        "$tty_f3"|"$tty_c"|"$tty_C"|"$f3"|"$t_c"|"$t_C")
                        stty sane
                        return $CANCEL
                        break;;
                        "$tty_f5"|"$f5" )
                        stty sane
                        return $REFRESH
                        break;;
                        "$t_b"|"$t_B" )
                        stty sane
                        return $REFRESH
                        break;;
                        "$tty_f10"|"$tty_q"|"$tty_Q"|"$f10"|"$t_q"|"$t_Q")
                        stty sane
                        return $EXIT
                        break;;
                        "$tty_r"|"$tty_R"|"$t_r"|"$t_R")
                        stty sane
                        return $CPROMPT
                        break;;
                       "$tty_ent"|"$tty_kent"|"012 012")
				printf "Pressing enter key alone\n"
                         stty sane
                         return $INERR
                         break;;
                        "$tty_0"|"$tty_k0"|"$t_0")
                        stty sane
                        return 0
                        break
                        ;;
                        "$tty_1"|"$tty_k1"|"$t_1")
                        stty sane
                        return 1
                        break
                        ;;
                        "$tty_2"|"$tty_k2")
                        stty sane
                        return 2
                        break
                        ;;
                        "$tty_3"|"$tty_k3")
                        stty sane
                        return 3
                        break
                        ;;
                        "$tty_4"|"$tty_k4")
                        stty sane
                        return 4
                        break
                        ;;
                        "$tty_5"|"$tty_k5")
                        stty sane
                        return 5
                        break
                        ;;
                        "$tty_6"|"$tty_k6")
                        stty sane
                        return 6
                        break
                        ;;
                        "$tty_7"|"$tty_k7")
                        stty sane
                        return 7
                        break
                        ;;
                       "$tty_8"|"$tty_k8") 
                        stty sane
                        return 8
                        break
                        ;;
                       "$tty_9"|"$tty_k9") 
                        stty sane
                        return 9
                        break
                        ;;
                        "$tty_10"|"$tty_k10")
                        stty sane
                        return 10
                        break
                        ;;
                        "$tty_11"|"$tty_k11")
                        stty sane
                        return 11
                        break
                        ;;
                        "$tty_12"|"$tty_k12")
                        stty sane
                        return 12
                        break
                        ;;
                        *)
                        continue
                        ;;
                esac
        done
        #stty echo
        stty $tty_save
}


	
#####################################################
# this is for multipath checking
#####################################################
multipath_check ()
{
	print_header
        MENU_ROW="15"
        MENU_COL="15"
			tput ed
	echo -e "\033[1m"
        tput cup  $((MENU_ROW-2)) 0 ; echo  "Multipath Checking"
	echo -e "\033[0m"
	printf "\n\n"
	cmd_path=` whereis multipath | awk '{print $2}'`
	cmd=` whereis multipath | awk '{print $1}'`
	m_status=`service multipathd status 2>/dev/null`
	if [[ "$cmd_path" == "" || $? != "0" ]]
	then
		echo -e "\033[1m"
		mul_arr[0]=" $cmd  is not configured on the server"
		echo -e "\033[0m"
	else
		multipath_op=`multipath -ll 2>/dev/null`
		if [[ "$multipath_op" == "" ]]
		then
			mul_arr[0]="No SAN Allocated";
		else
			# mul_arr[0]=`multipath -ll`
			multipath -ll > /$TMP_DIR/multipath.op
			
#  cat  multipath.op | awk '{gsub(/\]\[/,"-");gsub(/\\_/,"");print $1 " " $2 " " $3 " " $4}'


#mpath2 (360050768018e0334080000000000044f) dm-18 IBM,2145
#[size=24G][features=1 queue_if_no_path][hwhandler=0][rw]
#\_ round-robin 0 [prio=50][active]
# \_ 1:0:1:1 sde 8:64  [active][ready]
# \_ 2:0:1:1 sdi 8:128 [active][ready]
#\_ round-robin 0 [prio=10][enabled]
# \_ 1:0:0:1 sdc 8:32  [active][ready]
# \_ 2:0:0:1 sdg 8:96  [active][ready]
#mpath1 (360050768018e0334080000000000044e) dm-17 IBM,2145
#[size=24G][features=1 queue_if_no_path][hwhandler=0][rw]
#\_ round-robin 0 [prio=50][active]
# \_ 1:0:0:0 sdb 8:16  [active][ready]
# \_ 2:0:0:0 sdf 8:80  [active][ready]
#\_ round-robin 0 [prio=10][enabled]
# \_ 1:0:1:0 sdd 8:48  [active][ready]
# \_ 2:0:1:0 sdh 8:112 [active][ready]

cat  /$TMP_DIR/multipath.op | awk '{gsub(/\\_/,"");gsub(/\[size=/,"[");gsub(/\[hwhandler=/," ");gsub(/\[features=1 /," 1-");gsub(/\]\[rw\]/,"\] \[rw\]");gsub(/\[prio=/," ");print $1 " " $2 " " $3 " " $4}' > /$TMP_DIR/mul

while read lines
do

	
	p1=`echo $lines | awk '{print $1}'`
	p2=`echo $lines | awk '{print $2}'`
	p3=`echo $lines | awk '{print $3}'`
	p22=`echo $p2 | awk '{gsub(/\]/,"");print $1}'`
	if [[ `echo $lines | grep -i "round-robin" ` ]]
	then
		p33=`echo $p3 | awk '{gsub(/\]\[/," [");print $1 }'`
		p4=`echo $p3 | awk '{gsub(/\]\[/," [");print $2 }'`	
		p3=`echo $p33`
	else
		p4=`echo $lines | awk '{print $4}'`
	fi
		rval=`echo $p3 | awk '{gsub(/\]/,"");print }'`	
	 printf "%-15s %-35s  %-15s %-15s %-15s \n" "$p1" "$p22" "$rval" "$p4"

done < "/$TMP_DIR/mul"
rm -f /$TMP_DIR/mul /$TMP_DIR/multipath.op
		fi
	fi
	#tput cup $((MENU_ROW+5)) 0; echo $mul_arr[0]
        tput cup  $MENU_ROW $MENU_COL ; echo  "${mul_arr[0]}"
	# printline
	printf "Press enter to continue"
	read in
}

while true
do
	print_header
        d_flag=0
	dash_board
        d_flag=1
	menu
stty erase 
#	 stty -echo
	
	printf "Enter Your Choice:"
	# stty erase "^?"
	# stty erase "^H"
	#read input
	sig_trap
        get_opt
        ret=$?
case $ret in
		1)  performance_mgmt;audit_log 1 performance_mgmt;;
                2)  fs_detail;audit_log 2 Filesystem_details;;
		3)  error_report;audit_log 3 Eror_report ;;
		4)  network_mgm;audit_log 4 Network_details ;;
		5)
        		if [[ $user_id != "root" ]]
			then
				# printline
				printf "You should be  root inorder to perform this action \n"		
				# printline
				moveon
			else
				lvm_version=`rpm -q lvm2 2>/dev/null`
				if [[ $? == "0" ]]
				then
					more_lvm
					audit_log 5 Logical_Volume_Management
				else
				lvm_version=`rpm -q lvm 2>/dev/null`
				
				if [[ $? == "0" ]]
				then	
					rhl3_more_lvm
					audit_log 5 rhl3_Logical_Volume_Management
				else
					printf "Couldn't find the LVM version\n"
				fi
				fi
			fi
			;;		
		6)	
			if [[ $user_id != "root" ]]
        	        then
				# printline
        	                printf "You should be  root inorder to perform this action\n"
				# printline
        	                moveon
        	        else
				 multipath_check
		 		audit_log 6 Multipath_check
			fi
			;; 
		7) user_detail; audit_log 7 User_Details;;
		8)
			if [[ $user_id != "root" ]]
        	        then
				# printline
        	                printf "You should be  root inorder to perform this action\n"
				# printline
        	                moveon
        	        else
			 cluster_details 
		 		audit_log 6 cluster_details 
			fi
			;;
		# r|R) run_cmd;audit_log 11 Run_a_Command;;
		$CPROMPT)  run_cmd;audit_log 8 Run_a_Command;;
		#q|Q) exit 0 ;;
                $EXIT) exit_admin;;
		$HELP)
			 MENU_ROW="15"
                        MENU_COL="10"
                        tput civis
                        help_item="${1}"
                        print_header
                        arr[0]=`grep -A6 "MAIN_MENU:" /$ETC_DIR/help`
                        tput cup  $((MENU_ROW-1)) 0 ; echo  "[Help]"
                        tput cup  $MENU_ROW $MENU_COL ; echo  "${arr[0]}"
                        get_opt
                        tput cnorm
                        ;;
		 $INERR|$REFRESH|$DASHBOARD) continue;;
		*) continue ;;
	esac
done
