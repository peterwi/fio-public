#!/bin/bash
#
#

FIO="/usr/bin/fio"
HOSTLIST="/exa0/hostlist.txt"
FIOCONFIG="/exa0/fio.ini"
RESULTS_PATH="/exa0/fio-results"
SCRATCH_DIR="/exa0/fio-data"
SIZE="100M"

mkdir -p "${SCRATCH_DIR}" "${RESULTS_PATH}"

TS=`date +%Y.%m.%d-%H:%M:%S`

for NNODES in 1 2 ; do
	head -n ${NNODES} ${HOSTLIST} > ${HOSTLIST}.tmp
	for NJOBS in 1 2 ; do
		for BLOCKSIZE in 1M 10M ; do
			for SECTION in seqr seqw ; do
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
		done
	done
done

rm -f "${HOSTLIST}.tmp"

