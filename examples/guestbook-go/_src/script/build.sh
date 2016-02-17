#!/bin/bash

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Usage: ./script/build.sh [TAG] [USERNAME]

set -o errexit
set -o nounset
set -o pipefail

guestbook_version=${1:-latest}
username=${2:-kubernetes}
docker build --rm --force-rm -t kubernetes/guestbook-builder .
docker run --rm kubernetes/guestbook-builder | docker build -t "${username}/guestbook:${guestbook_version}" -
