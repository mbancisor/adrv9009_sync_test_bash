#!/bin/bash

iio_attr -c adrv9009-phy TRX_LO frequency $1
iio_attr -c adrv9009-phy-b TRX_LO frequency $1

