#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

current_country = None

total_cases = 0.0
total_deaths = 0.0
population = None
population_mismatch = False


def emit_result(country, cases, deaths, pop, mismatch):

    if country is None:
        return

    if mismatch or pop is None:
        pop = "NA"

    print("{}\t{}\t{}\t{}".format(
        country, cases, deaths, pop
    ))


for line in sys.stdin:

    try:
        country, pop, cases, deaths = line.strip().split("\t")

        cases = float(cases)
        deaths = float(deaths)

        if pop == "NA":
            pop = None
        else:
            pop = float(pop)

    except ValueError:
        continue

    if current_country != country:

        emit_result(
            current_country,
            total_cases,
            total_deaths,
            population,
            population_mismatch
        )

        current_country = country
        total_cases = 0.0
        total_deaths = 0.0
        population = None
        population_mismatch = False

    total_cases += cases
    total_deaths += deaths

    if pop is not None:

        if population is None:
            population = pop

        elif population != pop:
            population_mismatch = True


emit_result(
    current_country,
    total_cases,
    total_deaths,
    population,
    population_mismatch
)
