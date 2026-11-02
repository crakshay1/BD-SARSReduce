#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

current_continent = None
total_cases = 0.0
total_deaths = 0.0

def emit_result(continent, cases, deaths):
    if continent is None:
        return

    print("{}\t{}\t{}".format(
        continent, cases, deaths
    ))

for line in sys.stdin:
    try:
        continent, cases, deaths = line.strip().split("\t")
        cases = float(cases)
        deaths = float(deaths)
    except ValueError:
        continue

    if current_continent != continent:
        emit_result(current_continent, total_cases, total_deaths)

        current_continent = continent
        total_cases = 0.0
        total_deaths = 0.0

    total_cases += cases
    total_deaths += deaths

emit_result(current_continent, total_cases, total_deaths)
