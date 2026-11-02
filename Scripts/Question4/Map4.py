#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    try:
        if not row or row[0] == "dateRep":
            continue

        continent = row[8].strip()
        cases = float(row[2])
        deaths = float(row[3])

        if not continent:
            continue

        print("{}\t{}\t{}".format(
            continent, cases, deaths
        ))

    except (ValueError, IndexError):
        continue
