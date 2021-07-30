import { useState } from 'react';
import React from 'react'
import '../App.css'
import { Button } from "@material-ui/core";
import "react-date-range/dist/styles.css";
import "react-date-range/dist/theme/default.css";
import { DateRangePicker } from "react-date-range";

function Banner() {

    const [startDate, setStartDate] = useState(new Date());
    const [endDate, setEndDate] = useState(new Date());
    
    const selectionRange = {
        startDate: startDate,
        endDate: endDate,
        key: "selection",
      };

    function handleSelect(ranges) {
        setStartDate(ranges.selection.startDate);
        setEndDate(ranges.selection.endDate);
    }
    
    return (
        <div className='banner'>
            <div className='container'>
                <div className='banner__search'>

                </div>
                <div className='banner__booking'>
                    <Button variant='outlined'>Search</Button>
                </div>
            </div>
        </div>
    )
}

export default Banner
