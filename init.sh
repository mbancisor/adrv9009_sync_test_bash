#!/bin/bash

if [ $# -ne 0 ]
then

	SLAVE=$2
	MASTER=$1

	export IIOD_REMOTE=$SLAVE

		# disable RF seeder, doing it on SOM and Carrier breaks Sync
		iio_reg hmc7044-ext 0x3 0xf
		# SET SOM pulses to 8
		iio_reg	hmc7044 0x5a 0x4

		#PLL2 doubler // not needed
		#iio_reg	hmc7044 0x32 0x1
		#iio_reg	hmc7044 0x35 0x18
		#PLL2 doubler
		#iio_reg	hmc7044-car 0x32 0x1
		#iio_reg	hmc7044-car 0x35 0x18		
		#PLL2 doubler
		#iio_reg	hmc7044-ext 0x32 0x1
		#iio_reg	hmc7044-ext 0x35 0x18

	unset IIOD_REMOTE

	export IIOD_REMOTE=$MASTER

		# disable RF seeder, DOING IT ON THE SOM OR CARRIER BREAKS SYNC
		iio_reg hmc7044-ext 0x3 0xf
		# SET SOM pulses to 8
		iio_reg	hmc7044 0x5a 0x4

		#force vco caps
		#iio_reg hmc7044-car 0xb2 0x35

		#PLL2 doubler // not needed
		#iio_reg	hmc7044 0x32 0x1
		#iio_reg	hmc7044 0x35 0x18
		#PLL2 doubler
		#iio_reg	hmc7044-car 0x32 0x1
		#iio_reg	hmc7044-car 0x35 0x18		
		#PLL2 doubler
		#iio_reg	hmc7044-ext 0x32 0x1
		#iio_reg	hmc7044-ext 0x35 0x18

	unset IIOD_REMOTE


else
	echo master and slave IPs are needed as params

fi


