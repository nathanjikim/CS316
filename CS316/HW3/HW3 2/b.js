db.committees.aggregate([
    {$match: {_id: {$eq: "SSJU"}}},
    { $addFields: {
        chair_member: { $filter: {
            input: "$members",
            as: "member",
            cond: { $eq: ["$$member.role","Chairman"] }
    }}}},
    { $lookup: {
        from: "people",
        localField: "chair_member.id",
        foreignField: "_id",
        as: "ssju_chairman",
    }},
    {$unwind: "$ssju_chairman"},
    { $replaceRoot: {
        newRoot: "$ssju_chairman"}
    }
]).toArray()