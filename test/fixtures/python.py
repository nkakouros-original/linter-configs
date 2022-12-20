
#!/usr/bin/env python3

"""
This is designed so that it triggers the following errors/behaviors:
  - black:
      - last (empty) line would be deleted
      - long lines below 88 chars would not be reformatted
"""

from typing import List, Union
import maya
import os
import mymodule
import yaml

class myclass:
    pass  # noqa


class myclass:
    def __init__(self, arg1):
        print("thiiiis is a long string that is between 80 and 88 characters in length")
        assert yaml.load("{}") == []  # nosec assert_used
        q: List = []
        # mkdir os
        os.mkdir('/home/q', mode=777)
        os.open('home/q', mode=777)

    def helper(self): pass
    def user(self): self.helper()

# TODO something

# import builtins
import builtins

class String(builtins.str): pass

a = b = c = 1
if a == b or a == c:
    pass
print('foo' 'bar', 'baz')

a = "hello %s" % ("world")

l: Union[str, list] = []

from datetime import datetime
d = datetime.utcnow()
t = ((a, b))

import time
async def f():
    time.sleep(4)
