from collections import Counter, ChainMap, defaultdict
from functools import partial
from importlib import reload
from glob import glob
import itertools, more_itertools
import re

import numpy as np
import pandas as pd
from scipy.special import comb as nCr
