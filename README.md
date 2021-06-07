HowTo:
1) Create a hostlist.txt with all potential servers to be used for an FIO run
2) Start a FIO instance on each server (./server-ctrl.sh hostlist.txt start)
3) Adjust fio.ini
4) Adjust run-fio.sh
5) Run fio (./run-fio.sh)
6) Stop all FIO instances on each server (./server-ctrl.sh hostlist.txt stop)

