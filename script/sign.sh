#!/bin/sh

#  sign.sh
#  ClarityApp
#
#  Created by Yaguang Ding on 2019/3/19.
#  Copyright © 2019 Yaguang Ding. All rights reserved.
codesign --deep --verbose --force --sign "3rd Party Mac Developer Application: Ding Yaguang (X5ZZP6QUSQ)"  ClarityApp.app
