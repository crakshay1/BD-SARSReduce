#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    try:
        if not row or row[0] == "dateRep":
            continue

        week = row[1].strip()
        cases = float(row[2])
        deaths = float(row[3])
        continent = row[8].strip()

        if not continent or not week:
            continue

        print("{}\t{}\t{}\t{}".format(
            continent, week, cases, deaths
        ))

    except (ValueError, IndexError):
        continue
