# Copyright 2014 Google Inc.
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

FROM nvidia/caffe

RUN mkdir /deepdream
WORKDIR /deepdream

RUN apt-get -q update && \
  apt-get install --no-install-recommends -y --force-yes -q \
    build-essential \
    ca-certificates \
    git \
    python python-pip \
    python-numpy python-scipy python-imaging && \
  apt-get clean && \
  rm /var/lib/apt/lists/*_*

# Download and compile Caffe
RUN git clone https://github.com/BVLC/caffe
RUN cd caffe/scripts && ./download_model_binary.py ../models/bvlc_googlenet/

RUN pip install protobuf && pip install tornado --upgrade
RUN apt-get -q update && \
  apt-get install --no-install-recommends -y --force-yes -q \
    python-jsonschema && \
  apt-get clean && \
  rm /var/lib/apt/lists/*_*

ADD deepdream.py deepdream.py

ENTRYPOINT ["./deepdream.py"]
