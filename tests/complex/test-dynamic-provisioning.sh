#!/bin/bash

TEST_DIR="$(cd "$(dirname "${0}")" && pwd)"

source "${TEST_DIR}/lib.sh"

run -r master "${TEST_DIR}/test-inside-dynamic-provisioning.sh" "Test dynamic provisioning"
