var mapper5 = function() {
    var continent = this.continentExp;
    var week = this.year_week;
    var cases = this.cases_weekly;
    var deaths = this.deaths_weekly;

    if (typeof continent !== "string" ||
        typeof week !== "string" ||
        typeof cases !== "number" ||
        typeof deaths !== "number") {
        return;
    }

    emit(continent, {
        week: week,
        cases: cases,
        deaths: deaths
    });
};

var reducer5 = function(key, values) {
    var weeklyTotals = {};
    values.forEach(function(value) {
        var week = value.week;

        if (!weeklyTotals[week]) {
            weeklyTotals[week] = {
                cases: 0,
                deaths: 0
            };
        }

        weeklyTotals[week].cases += value.cases;
        weeklyTotals[week].deaths += value.deaths;
    });

    var result = {
        peak_cases: 0,
        peak_cases_weeks: [],
        peak_deaths: 0,
        peak_deaths_weeks: []
    };

    Object.keys(weeklyTotals).forEach(function(week) {
        var cases = weeklyTotals[week].cases;
        var deaths = weeklyTotals[week].deaths;

        if (cases > result.peak_cases) {
            result.peak_cases = cases;
            result.peak_cases_weeks = [week];
        } else if (cases === result.peak_cases) {
            result.peak_cases_weeks.push(week);
        }

        if (deaths > result.peak_deaths) {
            result.peak_deaths = deaths;
            result.peak_deaths_weeks = [week];
        } else if (deaths === result.peak_deaths) {
            result.peak_deaths_weeks.push(week);
        }
    });
    return result;
};

db.covid_weekly.mapReduce(
    mapper5,
    reducer5,
    {
        out: { replace: "MR5_MongoDB" }
    }
);

db.MR5_MongoDB.aggregate([
    {
        $project: {
            _id: 1,
            peak_cases_week: {
                $arrayElemAt: ["$value.peak_cases_weeks", 0]
            },
            peak_cases: "$value.peak_cases",
            peak_deaths_week: {
                $arrayElemAt: ["$value.peak_deaths_weeks", 0]
            },
            peak_deaths: "$value.peak_deaths"
        }
    },
    { $sort: { _id: 1 } },
    { $limit: 7 }
]);