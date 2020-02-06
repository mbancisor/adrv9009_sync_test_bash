#!/bin/bash


master_IP="192.168.1.60"
slave_IP="192.168.1.61"
run_all=0

LO=1000000000

samples=512
buffers=512

echo   1          2       3          4       5     6    7     
echo unsync  7044_setup  sync   setup_adrv  MCS   DMA  data

if [ $# -eq 0 ]
  then
    run_all=1		  
    echo "No arguments supplied - running everything"
fi

# 0 init --- should be done in the driver

echo init
./init.sh $master_IP $slave_IP

# 1 - unsync boards
if [ $# -eq 0 ] || [ $1 -eq 1 ]
then
	# unsync both boards
	sshpass -p 'analog' ssh root@$master_IP 'bash -s' < ./unsync.sh
	sshpass -p 'analog' ssh root@$slave_IP 'bash -s' < ./unsync.sh
	echo unsync done
	sleep 0.1
fi

# 2 - setup 7044s for sync
if [ $# -eq 0 ] || [ $2 -eq 1 ]
then
	echo continuous sysref
	./7044_setup.sh $master_IP $slave_IP
fi

# 3 - Sync boards -- step 2 needs to be run before in order to sync properly
if [ $# -eq 0 ] || [ $3 -eq 1 ]
then
	./sync.sh $master_IP $slave_IP
	echo sync done
fi

# 4 - setup ADRV9009
if [ $# -eq 0 ] || [ $4 -eq 1 ]
then
	#setup 90009
	sshpass -p 'analog' ssh root@$master_IP 'bash -s' < ./adrv_setup.sh $LO 
	sshpass -p 'analog' ssh root@$slave_IP 'bash -s' < ./adrv_setup.sh $LO
	echo setup done
fi

# 5 - MCS SYNC
if [ $# -eq 0 ] || [ $5 -eq 1 ]
then
	#MCS
	./mcs.sh $master_IP $slave_IP
	echo mcs done
fi


# 6 - DMA arm
if [ $# -eq 0 ] || [ $6 -eq 1 ]
then
	echo DMA arm
	./DMA_arm.sh $master_IP $slave_IP
fi

sleep 1

# 7 - Get data
if [ $# -eq 0 ] || [ $7 -eq 1 ]
then
	echo getting samples
	iio_readdev -n $master_IP -b $buffers -s $samples -T 10000 axi-adrv9009-rx-hpc > samples_master.dat &
	pid_master=$!
	iio_readdev -n $slave_IP -b $buffers -s $samples -T 10000 axi-adrv9009-rx-hpc > samples_slave.dat &
	pid_slave=$!

	#issue a sysref to trigger data capture
	sshpass -p 'analog' ssh root@$master_IP 'bash -s' < ./sysref.sh
	
	#wait for the data to get captured
	while kill -0 $pid_master &> /dev/null ; do
		echo "Waiting for master sample data"
		sleep 1
	done
	
	while kill -0 $pid_slave &> /dev/null ; do
		echo "Waiting for slave sample data"
		sleep 1
	done

	python3 main.py &
fi












