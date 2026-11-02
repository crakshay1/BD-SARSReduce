var mapper3 = function() {
    var country = this.countriesAndTerritories;
    var cases = this.cases_weekly;
    var deaths = this.deaths_weekly;

    if (typeof country !== "string" ||
        typeof cases !== "number" ||
        typeof deaths !== "number") {
        return;
    }

    emit(country, {
        total_cases: cases,
        total_deaths: deaths
    });
};


var reducer3 = function(key, values) {
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
    mapper3,
    reducer3,
    {
        out: {
            replace: "MR3_MongoDB"
        },
        finalize: function(key, value) {

            value.deaths_to_cases_ratio =
                value.total_cases === 0
                ? null
                : (value.total_deaths / value.total_cases) * 100;

            return value;
        }
    }
);

db.MR3_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1,
        "value.deaths_to_cases_ratio": 1
    }
).sort({ _id: 1 }).limit(5);

db.MR3_MongoDB.find(
    {},
    {
        _id: 1,
        "value.total_cases": 1,
        "value.total_deaths": 1,
        "value.deaths_to_cases_ratio": 1
    }
).sort({ _id: -1 }).limit(5);