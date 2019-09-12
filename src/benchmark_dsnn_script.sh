#!/bin/bash

MACHINES=( 158.251.93.8:3302 158.251.93.8:3303 158.251.93.8:3304 158.251.93.8:3305 158.251.93.8:3306 158.251.93.8:3307 158.251.93.8:3308 )

SEEDS=( 7773860	4205942	9656760	6874483	9781075	43539	171173	5537971	1151470	7267171	9065070	2090548	5029588	3816764	8645216	2889327	9599633	4761570	1878940	8296541	8209629	6451117	1556504	5686907	4096916	7520534	1138224	28173	1836819	6283020)


unset inputcsvfile
unset inputlogfile
unset elapsedoutputfile
unset M
unset CURRSEED
unset var
unset elapsed
unset RUNNR

###########
inputcsvfile="../../20ng_best_config.csv"
###########


inputlogfile="tuning_progress_20ng-benchmarking.log"
elapsedoutputfile="benchmark_results.csv"

eval "sed -i -e '/logging.path:str/s/=[[:alnum:]_-]\+\.log/=$inputlogfile/' $inputcsvfile"



function join_by { local IFS="$1"; shift; echo "$*"; }



for M in $(seq 1 ${#MACHINES[@]})
do
	var=$(eval join_by , "${MACHINES[@]:0:$M}")
	echo $var

	eval  "sed -i -e  '/master.nodelist:str_list/s/=.\+/=$var/' $inputcsvfile"
	
	echo "#run elapsed[secs][machines:$M]" |tee -a $elapsedoutputfile
	#elapsed_times=()
	RUNNR=1
	for CURRSEED in "${SEEDS[@]}"
	do
		echo "Current seed: $CURRSEED"

		# replace the current seed in order to alter the results.
		eval "sed -i -e  '/seed:int=/s/[0-9]\+/$CURRSEED/' $inputcsvfile"

		# exeecute dsnn
		julia run_experiments.jl -c $inputcsvfile

		# extracting elapsed time from tuning_progress_ds3-benchmarking.log
		elapsed=$(eval "cat  $inputlogfile|grep 'Elapsed time:'|cut -d ' ' -f3")

		#elapsed_times+=($elapsed)
		echo "$RUNNR $elapsed" |tee -a $elapsedoutputfile
		RUNNR=$((RUNNR+1))
	done
done
