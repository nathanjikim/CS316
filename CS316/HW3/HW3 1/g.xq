<result>
    {
        for $i in distinct-values(//person/role[@current='1']/@state)
        let $i1 := //person[@state=$i and role[@current='1']]
        order by $i
        return element {$i} {
            for $g in distinct-values(//person/@gender)
            let $g1 := //person[@gender=$g and role[@current='1']]
            let $c := count($g1[@gender=$g]/role[@current='1' and @state=$i])
            return element {$g}{attribute count {$c}}
        }
    }
</result>