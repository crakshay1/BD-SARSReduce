#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

current_continent = None
weekly_totals = {}

def emit_result(continent, weekly_totals):
    if continent is None or not weekly_totals:
        return

    peak_cases = max(v[0] for v in weekly_totals.values())
    peak_deaths = max(v[1] for v in weekly_totals.values())

    peak_cases_weeks = [
        week for week, values in weekly_totals.items()
        if values[0] == peak_cases
    ]

    peak_deaths_weeks = [
        week for week, values in weekly_totals.items()
        if values[1] == peak_deaths
    ]

    print("{}\t{}\t{}\t{}\t{}".format(
        continent,
        ",".join(sorted(peak_cases_weeks)),
        peak_cases,
        ",".join(sorted(peak_deaths_weeks)),
        peak_deaths
    ))

for line in sys.stdin:
    try:
        continent, week, cases, deaths = line.strip().split("\t")

        cases = float(cases)
        deaths = float(deaths)

    except ValueError:
        continue

    if current_continent != continent:

        emit_result(current_continent, weekly_totals)

        current_continent = continent
        weekly_totals = {}

    if week not in weekly_totals:
        weekly_totals[week] = [0.0, 0.0]

    weekly_totals[week][0] += cases
    weekly_totals[week][1] += deaths

emit_result(current_continent, weekly_totals)
