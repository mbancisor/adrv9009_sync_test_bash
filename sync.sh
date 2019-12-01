#!/bin/bash

if [ $# -ne 0 ]
then

        SLAVE=$2
        MASTER=$1

	export IIOD_REMOTE=$MASTER

                # Reseed request to clk1 -----> syncs the output of the 1st clk 
                iio_reg hmc7044-ext 0x1 0x80
                iio_reg hmc7044-ext 0x1 0x00
		sleep 0.1
		# pulse request to CLK1----> syncs the outputs of CLK2
		iio_attr -q -d hmc7044-ext sysref_request 1
		sleep 0.1

        unset IIOD_REMOTE

        export IIOD_REMOTE=$SLAVE

          	# CLK2 sync pin mode as Pulsor so it doesn't resync on next pulse
        	iio_reg hmc7044-car 0x5 0x82

        unset IIOD_REMOTE

        export IIOD_REMOTE=$MASTER

          	# CLK2 sync pin mode as Pulsor so it doesn't resync on next pulse
        	iio_reg hmc7044-car 0x5 0x82
		sleep 0.1

		# pulse request to CLK1----> syncs the outputs of CLK3
		iio_attr -q -d hmc7044-ext sysref_request 1
		sleep 0.1
          	
		# CLK3 sync pin mode as Pulsor so it doesn't resync on next pulse
        	iio_reg hmc7044 0x5 0x83
		
        unset IIOD_REMOTE

        export IIOD_REMOTE=$SLAVE

          	# CLK3 sync pin mode as Pulsor so it doesn't resync on next pulse
        	iio_reg hmc7044 0x5 0x83

        unset IIOD_REMOTE


else
        echo master and slave IPs are needed as params

fi

