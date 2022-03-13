<result>
    {
        for $i in //person
        let $id := $i/@id
        where count(congress/committees/committee/member[@id=$id])>5
        order by $i/@name ascending
        return <member> {string($i/@name)}  </member>
    }
</result>