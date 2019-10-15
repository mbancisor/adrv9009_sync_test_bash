#!/bin/bash

if [ $# -ne 0 ]
then

	SLAVE=$2
	MASTER=$1

	export IIOD_REMOTE=$SLAVE

		#sync propagates through pll2
		iio_reg hmc7044 0x5 0x43
		# one pulse
		iio_reg hmc7044 0x5a 0x1

	unset IIOD_REMOTE

	export IIOD_REMOTE=$MASTER

		#sync propagates through pll2
		iio_reg hmc7044 0x5 0x43
		# one pulse
		iio_reg hmc7044 0x5a 0x1
	
		# issue sysref - will break jesd link
		iio_attr -q -d hmc7044-ext sysref_request 1

		# Sync as pulse generator	
		iio_reg hmc7044-car 0x5 0x83
		iio_reg hmc7044 0x5 0x83

	unset IIOD_REMOTE


	export IIOD_REMOTE=$SLAVE

		#Sync as pulse generator
		iio_reg hmc7044-car 0x5 0x83
		iio_reg hmc7044 0x5 0x83

	unset IIOD_REMOTE

else
	echo master and slave IPs are needed as params

fi

