<result>
    {
        for $i in //person
        let $b := $i/role[position()=last()]
        where $b/@type='rep' and $i/role/@state='NC'
        order by $b/xs:integer(@district)
        return <representative name="{$i/@name}" district="{$b/@district}" party="{$b/@party}"/>
    }
</result>