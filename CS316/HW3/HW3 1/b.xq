<result>
    {
        for $i in //committee
        let $i1 := $i[@code='SSJU']/member[@role='Chairman']
        for $p in //person[@id=$i1/@id]
        return $p
    }
</result>