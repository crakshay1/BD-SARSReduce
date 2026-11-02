#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    try:
        if not row or row[0] == "dateRep":
            continue

        country = row[4].strip()
        cases = float(row[2])
        deaths = float(row[3])

        if not country:
            continue

        print("{}\t{}\t{}".format(
            country, cases, deaths
        ))

    except (ValueError, IndexError):
        continue
