db.people.aggregate([
        {$addFields: {
            current: { $arrayElemAt: ["$roles", -1]}
        }},
        {$group: {
            _id: {
                "state": "$current.state",    
            },
            M: { $sum: { $cond: [
                { $eq: [ "$gender","M"]},
                1,
                0
            ]}},
            F: { $sum: { $cond: [
                { $eq: [ "$gender","F"]},
                1,
                0
            ]}} 
        }},
        {$project: {
            _id: 0,
            state: "$_id.state",
            M: 1,
            F: 1,
        }},
        {$sort: {
            state: 1
        }}
    ]).toArray()