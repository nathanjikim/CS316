db.people.aggregate([
    { $lookup: {
        from: "committees",
        localField: "_id",
        foreignField: "members.id",
        as: "matched",
    }},
    { $match: {
           $expr: {$gt: [{$size: "$matched"}, 5]}
         }
    },
    {$project:{
        _id: 0,
        name: 1
    }},
    {$sort: {
        name: 1
    }}
]).toArray()
