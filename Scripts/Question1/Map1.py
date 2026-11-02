#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    try:
        # Ignore the header
        if not row or row[0] == "dateRep":
            continue

        # Dataset columns:
        # 2 = cases_weekly
        # 3 = deaths_weekly
        # 4 = countriesAndTerritories
        cases = row[2].strip()
        deaths = row[3].strip()
        country = row[4].strip()

        if not country or not cases or not deaths:
            continue

        x = float(cases)
        y = float(deaths)

        # n, x, y, x², y², xy
        print("{}\t1\t{}\t{}\t{}\t{}\t{}".format(
            country, x, y, x * x, y * y, x * y
        ))

    except (ValueError, IndexError):
        continue
