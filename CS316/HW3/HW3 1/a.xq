<result>
    {
        for $i in //person
        where starts-with($i/@name, 'Angus') or starts-with($i/@name, 'Bernard')
        return $i
    }
</result>
