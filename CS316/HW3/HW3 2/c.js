db.people.aggregate([
    {$match: { $and: [{birthday: { $lt: ISODate("1946-01-01") }},{gender: {$eq: "M"}}]}},
    { $addFields: {
        age: {$subtract: [2021,{$year: "$birthday"}]},
        current: { $arrayElemAt: ["$roles", -1]}
    }},
    {$project: {
        _id: 0,
        name: 1,
        type: "$current.type",
        age: 1,
    }},
    {$sort: {
        age: 1,
        name: 1
    }}
]).toArray()
