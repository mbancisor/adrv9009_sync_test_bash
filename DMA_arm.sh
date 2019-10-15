#!/bin/bash

if [ $# -ne 0 ]
then

	SLAVE=$2
	MASTER=$1

	export IIOD_REMOTE=$SLAVE

	iio_reg axi-adrv9009-rx-hpc 0x80000044 0x8
	var=$(iio_reg axi-adrv9009-rx-hpc 0x80000068)
	while [ $var == "0x0" ] 
	do 
		iio_reg axi-adrv9009-rx-hpc 0x80000044 0x8
		var=$(iio_reg axi-adrv9009-rx-hpc 0x80000068)
		echo .
	done

	unset IIOD_REMOTE

	export IIOD_REMOTE=$MASTER

	iio_reg axi-adrv9009-rx-hpc 0x80000044 0x8
	var=$(iio_reg axi-adrv9009-rx-hpc 0x80000068)
	while [ $var == "0x0" ] 
	do 
		iio_reg axi-adrv9009-rx-hpc 0x80000044 0x8
		var=$(iio_reg axi-adrv9009-rx-hpc 0x80000068)
		echo .
	done

	unset IIOD_REMOTE

else
	echo master and slave IPs are needed as params

fi

