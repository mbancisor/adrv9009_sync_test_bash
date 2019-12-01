#!/bin/bash

if [ $# -ne 0 ]
then

	MASTER=$1
	SLAVE=$2

	export IIOD_REMOTE=$SLAVE
	
	# CLK2 sync pin mode as SYNC
	iio_reg hmc7044-car 0x5 0x42
	
	# CLK3 sync pin mode as SYNC
	iio_reg hmc7044 0x5 0x43
	
	# restart request for all 7044
	iio_reg hmc7044 0x1 0x62
	iio_reg hmc7044-car 0x1 0x62
	iio_reg hmc7044-ext 0x1 0x02
	sleep 0.1
	iio_reg hmc7044-ext 0x1 0x00
	sleep 0.1
	iio_reg hmc7044-car 0x1 0x60
	sleep 0.1
	iio_reg hmc7044 0x1 0x60
	sleep 0.1


	unset IIOD_REMOTE

	export IIOD_REMOTE=$MASTER

	# CLK2 sync pin mode as SYNC
	iio_reg hmc7044-car 0x5 0x42
	
	# CLK3 sync pin mode as SYNC
	iio_reg hmc7044 0x5 0x43
	
	# restart request for all 7044
	iio_reg hmc7044 0x1 0x62
	iio_reg hmc7044-car 0x1 0x62
	iio_reg hmc7044-ext 0x1 0x02
	sleep 0.1
	iio_reg hmc7044-ext 0x1 0x00
	sleep 0.1
	iio_reg hmc7044-car 0x1 0x60
	sleep 0.1
	iio_reg hmc7044 0x1 0x60
	sleep 0.1

	unset IIOD_REMOTE

else
	echo master and slave IPs are needed as params

fi

