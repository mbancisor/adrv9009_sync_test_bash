#!/bin/bash

if [ $# -ne 0 ]
then

	SLAVE=$1
	MASTER=$2

	export IIOD_REMOTE=$SLAVE

	iio_reg hmc7044 0x5a 0x0
	#sync propagates through pll2
	iio_reg hmc7044 0x5 0x43
	iio_reg hmc7044-car 0x5 0x42

	unset IIOD_REMOTE

	export IIOD_REMOTE=$MASTER

	iio_reg hmc7044 0x5a 0x0
	#sync propagates through pll2
	iio_reg hmc7044 0x5 0x43
	iio_reg hmc7044-car 0x5 0x42
	
	sleep 0.1
	iio_attr -q -d hmc7044-ext sysref_request 1

	unset IIOD_REMOTE

else
	echo master and slave IPs are needed as params

fi

