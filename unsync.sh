#!/bin/bash

iio_reg hmc7044 0x1 0x62
sleep 0.1
iio_reg hmc7044 0x1 0x60
