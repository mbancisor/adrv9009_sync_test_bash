#!/bin/bash


iio_attr -q -d hmc7044-ext sysref_request 1
sleep 0.1
iio_attr -q -d hmc7044-ext sysref_request 1
sleep 0.1
