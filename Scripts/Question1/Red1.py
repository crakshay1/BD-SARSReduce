#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import math


def emit_result(country, n, sum_x, sum_y, sum_x2, sum_y2, sum_xy):
    if country is None:
        return

    numerator = n * sum_xy - sum_x * sum_y

    variance_x = n * sum_x2 - sum_x * sum_x
    variance_y = n * sum_y2 - sum_y * sum_y

    if n < 2 or variance_x <= 0 or variance_y <= 0:
        correlation = "NA"
    else:
        denominator = math.sqrt(variance_x * variance_y)
        correlation = numerator / denominator

    print("{}\t{}\t{}".format(country, n, correlation))


current_country = None
n = 0
sum_x = 0.0
sum_y = 0.0
sum_x2 = 0.0
sum_y2 = 0.0
sum_xy = 0.0

for line in sys.stdin:
    parts = line.strip().split("\t")

    if len(parts) != 7:
        continue

    country = parts[0]

    try:
        count = int(parts[1])
        x = float(parts[2])
        y = float(parts[3])
        x2 = float(parts[4])
        y2 = float(parts[5])
        xy = float(parts[6])
    except ValueError:
        continue

    if current_country is not None and country != current_country:
        emit_result(
            current_country, n, sum_x, sum_y,
            sum_x2, sum_y2, sum_xy
        )

        n = 0
        sum_x = 0.0
        sum_y = 0.0
        sum_x2 = 0.0
        sum_y2 = 0.0
        sum_xy = 0.0

    current_country = country

    n += count
    sum_x += x
    sum_y += y
    sum_x2 += x2
    sum_y2 += y2
    sum_xy += xy

emit_result(
    current_country, n, sum_x, sum_y,
    sum_x2, sum_y2, sum_xy
)
