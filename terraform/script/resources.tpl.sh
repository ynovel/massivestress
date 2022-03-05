#!/bin/sh
%{ if is_remote }
    wget -O resources.txt "${resources_url}"
%{ else }
    cp /tmp/resources/resources.txt ./
%{ endif }
