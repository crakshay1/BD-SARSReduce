var mapper4 = function() {
    var continent = this.continentExp;
    var cases = this.cases_weekly;
    var deaths = this.deaths_weekly;

    if (typeof continent !== "string" ||
        typeof cases !== "number" ||
        typeof deaths !== "number") {
        return;
    }

    emit(continent, {
        total_cases: cases,
        total_deaths: deaths
    });
};

var reducer4 = function(key, values) {
    var result = {
        total_cases: 0,
        total_deaths: 0
    };

    values.forEach(function(value) {
        result.total_cases += value.total_cases;
        result.total_deaths += value.total_deaths;
    });

    return result;
};

db.covid_weekly.mapReduce(
    mapper4,
    reducer4,
    {
        out: { replace: "MR4_MongoDB" }
    }
);

db.MR4_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1
    }
).sort({ _id: 1 });

db.MR4_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1
    }
).sort({ _id: 1 });