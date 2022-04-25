#!/usr/bin/env python3

"""
This is designed so that it triggers the following errors/behaviors:
  - black:
      - last (empty) line would be deleted
      - long lines below 88 chars would not be reformatted
"""

import maya
import os
import mymodule


class myclass:
    pass


class myclass:
    def __init__(self, arg1):
        print("thiiiis is a long string that is between 80 and 88 characters in length")

