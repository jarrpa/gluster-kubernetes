#!/bin/bash

scp -qrF ssh-config ../deploy master:
scp -qrF ssh-config ../hello_world master:
