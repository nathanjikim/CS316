db.people.aggregate([
    { $addFields: {
        current: { $arrayElemAt: ["$roles", -1]},
        first: { $arrayElemAt: ["$roles", 0]}
    }},
    {$match: {$or: [{name: /Gregorio /},{$expr: { $ne: [ "$first.party", "$current.party" ]}}]}},
    {$project: {
        _id: 0,
        name: 1
    }},
    {$sort: {
        name: 1
    }}
]).toArray()
