#!/bin/bash

wget -P cri-o -r -np -nd -A "*.rpm" -R "*rhaos*" http://cbs.centos.org/kojifiles/packages/cri-o/1.11.0/
