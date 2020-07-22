#!/bin/sh

#  run.sh
#  
#
#  Created by Andrii Vysotskyi on 01.05.2020.
#  

carthage bootstrap --platform iOS --cache-builds --no-use-binaries
open HighwayCode.xcodeproj
