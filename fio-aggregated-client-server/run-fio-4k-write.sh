#!/bin/bash
#
#

FIO="/usr/bin/fio"
HOSTLIST=/$PWD/hostlist.txt
FIOCONFIG=$PWD/fio-4k.ini
RESULTS_PATH=$PWD/fio-results
SCRATCH_DIR="/mnt/test"
SIZE="32G"
NJOBS=4
BLOCKSIZE=4096
SECTION=seqw


mkdir -p "${SCRATCH_DIR}" "${RESULTS_PATH}"

TS=`date +%Y.%m.%d-%H:%M:%S`

for NNODES in 1 2 3 4 5 6 8 10 20 30 34 ; do
	head -n ${NNODES} ${HOSTLIST} > ${HOSTLIST}.tmp
		LOGFILENAME="${TS}_-_nnodes-${NNODES}_njobs-${NJOBS}_bs-${BLOCKSIZE}_section-${SECTION}.json"
		LOGFILE="${RESULTS_PATH}/${LOGFILENAME}"
		export SIZE="${SIZE}"
		export SCRATCH_DIR="${SCRATCH_DIR}"
		export NJOBS="${NJOBS}"
		export BLOCKSIZE="${BLOCKSIZE}"
		export LOGFILE="${LOGFILE}"
		echo "----- ${TS}_-_nnodes-${NNODES}_njobs-${NJOBS}_bs-${BLOCKSIZE}_section-${SECTION} -----" | tee -a fio_${TS}.log
		${FIO}  --output-format=json+ \
			--output=${LOGFILE} \
			--client=${HOSTLIST}.tmp \
			--section=${SECTION} \
			${FIOCONFIG} 2>&1 | tee -a fio_${TS}.log
		sed -n '/^{.*/,$p' ${LOGFILE} > ${LOGFILE/.json/_clean.json}
	sleep 3
done

rm -f "${HOSTLIST}.tmp"

