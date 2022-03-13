<result>
    {
        for $i in //person
        let $age := 2021-fn:year-from-date($i/@birthday)
        let $b := $i/role[position()=last()]/@type
        where $i/@gender='M' and xs:date($i/@birthday) <= xs:date("1945-12-31")
        order by $age ascending, $i/@name ascending
        return <male name="{$i/@name}" age="{$age}" type="{$b}"/>
    }
</result>
