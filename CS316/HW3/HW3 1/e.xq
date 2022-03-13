<result>
    {
        for $i in //person
        let $count := count(distinct-values($i/role/@party))
        where $count=2
        return <member> {string($i/@name)}  </member>
    }
</result>