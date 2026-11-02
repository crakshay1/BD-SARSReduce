var mapper2 = function() {
    var country = this.countriesAndTerritories;
    var cases = this.cases_weekly;
    var deaths = this.deaths_weekly;
    var population = this.popData2019;

    if (typeof country !== "string" ||
        typeof cases !== "number" ||
        typeof deaths !== "number") {
        return;
    }

    var validPopulation =
        typeof population === "number" && population > 0
        ? population
        : null;

    emit(country, {
        total_cases: cases,
        total_deaths: deaths,
        population: validPopulation
    });
};

var reducer2 = function(key, values) {
    var result = {
        total_cases: 0,
        total_deaths: 0,
        population: null,
        population_mismatch: false
    };

    values.forEach(function(value) {
        result.total_cases += value.total_cases;
        result.total_deaths += value.total_deaths;

        if (value.population !== null) {

            if (result.population === null) {
                result.population = value.population;
            }
            else if (result.population !== value.population) {
                result.population_mismatch = true;
            }
        }
    });

    if (result.population_mismatch) {
        result.population = null;
    }

    return result;
};

db.covid_weekly.mapReduce(
    mapper2,
    reducer2,
    {
        out: { replace: "MR2_MongoDB" }
    }
);

db.MR2_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1,
        "value.population": 1
    }
).sort({ _id: 1 }).limit(5)

db.MR2_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1,
        "value.population": 1
    }
).sort({ _id: -1 }).limit(5)