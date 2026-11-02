#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

current_country = None

total_cases = 0.0
total_deaths = 0.0


def emit_result(country, cases, deaths):

    if country is None:
        return

    if cases == 0:
        ratio = "NA"
    else:
        ratio = (deaths / cases) * 100

    print("{}\t{}\t{}\t{}".format(
        country, cases, deaths, ratio
    ))


for line in sys.stdin:

    try:
        country, cases, deaths = line.strip().split("\t")

        cases = float(cases)
        deaths = float(deaths)

    except ValueError:
        continue

    if current_country != country:

        emit_result(
            current_country,
            total_cases,
            total_deaths
        )

        current_country = country
        total_cases = 0.0
        total_deaths = 0.0

    total_cases += cases
    total_deaths += deaths


emit_result(
    current_country,
    total_cases,
    total_deaths
)
