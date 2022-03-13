db.people.aggregate([
    { $addFields: {
        current: { $arrayElemAt: ["$roles", -1]}
    }},
    {$match: {$and: [{"current.state": {$eq: "NC"}}, {"current.type": {$eq: "rep"}}]}},
    {$project: {
        _id: 0,
        name: 1,
        district: "$current.district",
        party: "$current.party"
    }},
    {$sort: {
        district: 1
    }}
]).toArray()
