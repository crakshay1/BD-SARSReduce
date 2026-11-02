
var mapper = function() {
    var country = this.countriesAndTerritories;
    var x = this.cases_weekly;
    var y = this.deaths_weekly;

    if (
        typeof country !== "string" ||
        typeof x !== "number" ||
        typeof y !== "number"
    ) {
        return;
    }

    emit(country, {
        n: 1,
        sum_x: x,
        sum_y: y,
        sum_x2: x * x,
        sum_y2: y * y,
        sum_xy: x * y
    });
};



var reducer = function(key, values) {
    var result = {
        n: 0,
        sum_x: 0,
        sum_y: 0,
        sum_x2: 0,
        sum_y2: 0,
        sum_xy: 0
    };

    values.forEach(function(v) {
        result.n += v.n;
        result.sum_x += v.sum_x;
        result.sum_y += v.sum_y;
        result.sum_x2 += v.sum_x2;
        result.sum_y2 += v.sum_y2;
        result.sum_xy += v.sum_xy;
    });

    return result;
};



var finalize = function(key, value) {
    var n = value.n;
    var variance_x = n * value.sum_x2 -
                     value.sum_x * value.sum_x;

    var variance_y = n * value.sum_y2 -
                     value.sum_y * value.sum_y;

    if (n < 2 || variance_x <= 0 || variance_y <= 0) {
        value.pearson_r = null;
    } else {
        var numerator = n * value.sum_xy - value.sum_x * value.sum_y;
        var denominator = Math.sqrt(variance_x * variance_y);

        value.pearson_r = numerator / denominator;
    }

    return value;
};



db.covid_weekly.mapReduce(
    mapper,
    reducer,
    {
        out: { replace: "MR1_MongoDB" },
        finalize: finalize
    }
);

db.MR1_MongoDB.find().sort({ _id: 1 })

db.MR1_MongoDB.find(
    {},
    { _id: 1, "value.n": 1, "value.pearson_r": 1 }
).sort({ _id: 1 }).limit(5)

db.MR1_MongoDB.find(
    {},
    { _id: 1, "value.n": 1, "value.pearson_r": 1 }
).sort({ _id: -1 }).limit(5)
