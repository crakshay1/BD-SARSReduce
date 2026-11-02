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

        # Population may be missing in some weekly records
        population = row[7].strip()

        if not country:
            continue

        if population == "":
            population = "NA"
        else:
            population = float(population)

            if population <= 0:
                population = "NA"

        print("{}\t{}\t{}\t{}".format(
            country, population, cases, deaths
        ))

    except (ValueError, IndexError):
        continue
